//
//  MessageViewController.swift
//  Tunein
//
//  Created by Zeev Vax on 9/6/21.
//

import Foundation
import UIKit

class MessageViewController: UIViewController {
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var showMessageConstarint: NSLayoutConstraint!
  @IBOutlet weak var hideMessageConstarint: NSLayoutConstraint!
  
  private var message: String?
  
  static func create(message: String) -> MessageViewController {
    let vc = create(storyboardName: "Main") as! MessageViewController
    vc.message = message
    vc.modalPresentationStyle = .overFullScreen
    return vc
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.alpha = 0.0
    messageLabel.text = message
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateMessage()
  }
 
  private func animateMessage() {
    UIView.animate(withDuration: 2.0, animations: { [weak self] in
      guard let self = self else { return }
      self.view.alpha = 1.0
      self.showMessageConstarint.isActive = true
      self.hideMessageConstarint.isActive = false
    }, completion: { [weak self] finish in
      guard let self = self else { return }
      UIView.animate(withDuration: 2.0, animations: { [weak self] in
        guard let self = self else { return }
        self.messageLabel.alpha = 0.5
      }, completion: { [weak self] finish in
        guard let self = self else { return }
        self.dismiss(animated: true, completion: nil)
      })
    })
  }
}

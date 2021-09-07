//
// Created by Zeev Vax on 9/5/21.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  private var delegate: ChildViewControllerDelegate?
  private var elementList = [TuneElement]()

  static func create(elementList: [TuneElement], delegate: ChildViewControllerDelegate?) -> ListViewController {
    let vc = create(storyboardName: "Main") as! ListViewController
    vc.elementList = elementList
    vc.delegate = delegate
    return vc
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    elementList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewTableViewCell", for: indexPath) as! ListViewTableViewCell
    cell.setUp(tuneEntry: elementList[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let element = elementList[indexPath.row]
    if element.type == .link || element.type == .children {
      if let path = element.path {
        let linkDataSource = DataSource()
        loadingIndicator.startAnimating()
        linkDataSource.loadLinkData(path: path) { [weak self] result in
          guard let self = self else { return }
          self.loadingIndicator.stopAnimating()
          switch result {
          case .success:
            if let delegate = self.delegate {
              delegate.openChildView(dataSource: linkDataSource)
            } else {
              var vc: UIViewController
              if linkDataSource.shouldLoadListView() {
                vc = ListViewController.create(elementList: linkDataSource.elementList, delegate: nil)
              } else {
                vc = CollectionViewController.create(dataSource: linkDataSource, delegate: nil)
              }
              vc.title = linkDataSource.title
              self.navigationController?.pushViewController(vc, animated: true)
            }
          case .failure(let error):
            self.handleError(error)
          }
        }
      } else {
        handleError("URL path is missing")
      }
    } else if let path = element.path {
      if let delegate = delegate {
        delegate.presentMessage(message: path)
      } else {
        present(MessageViewController.create(message: path), animated: true)
      }
      //AudioPlayer.shared.playAudio(path: path)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

  private func handleError(_ error: Error) {
    UIAlertController(title: "Sorry", message: error.localizedDescription, preferredStyle: .alert).show(self, sender: nil)
  }
}

//
//  ViewController.swift
//  Tunein
//
//  Created by Zeev Vax on 9/4/21.
//

import UIKit

protocol ChildViewControllerDelegate {
  func openListView(entry: [TuneElement])
  func openChildView(dataSource: DataSource)
  func presentMessage(message: String)
  func handleError(_ error: Error)
}

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate/*, UICollectionViewDelegateFlowLayout*/ {
  @IBOutlet weak var topLinksCollectionView: UICollectionView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  
  private var topLinksList = [LinkElement]()
  private var elementList = [TuneElement]()
  private let dataSource = DataSource()

  override func viewDidLoad() {
    super.viewDidLoad()

    loadingIndicator.startAnimating()
    dataSource.loadInitialData { [weak self] result in
      guard let self = self else { return }
      self.loadingIndicator.stopAnimating()
      switch result {
      case .success:
        self.topLinksList = self.dataSource.topLinksList
        self.elementList = self.dataSource.elementList
        self.title = self.dataSource.title
        self.loadViews()
      case .failure(let error):
        self.handleError(error)
      }
    }
  }

  private func loadViews() {
    topLinksCollectionView.reloadData()
    var vc: UIViewController
    if dataSource.shouldLoadListView() {
      vc = ListViewController.create(elementList: elementList, delegate: self)
    } else {
      vc = CollectionViewController.create(dataSource: dataSource, delegate: self)
    }
    addVC(vc, frame: contentView.frame)
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    topLinksList.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHeaderCollectionViewCell", for: indexPath) as! TopHeaderCollectionViewCell
    cell.titleLabel.text = topLinksList[indexPath.row].text
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let path = topLinksList[indexPath.row].path {
      loadingIndicator.startAnimating()
      dataSource.loadLinkData(path: path) { [weak self] result in
        guard let self = self else { return }
        self.loadingIndicator.stopAnimating()
        switch result {
        case .success:
          self.elementList = self.dataSource.elementList
          self.loadViews()
          case .failure(let error):
            self.handleError(error)
        }
      }
    } else {
      handleError("Missing path")
    }
  }
}

extension MainViewController: ChildViewControllerDelegate {
  func openListView(entry: [TuneElement]) {
    let vc = ListViewController.create(elementList: entry, delegate: nil)
    navigationController?.pushViewController(vc, animated: true)
  }

  func openChildView(dataSource: DataSource) {
    var vc: UIViewController
    if dataSource.shouldLoadListView() {
      vc = ListViewController.create(elementList: dataSource.elementList, delegate: nil)
    } else {
      vc = CollectionViewController.create(dataSource: dataSource, delegate: nil)
    }
    vc.title = dataSource.title
    navigationController?.pushViewController(vc, animated: true)
  }

  func presentMessage(message: String) {
    present(MessageViewController.create(message: message), animated: true)
  }

  func handleError(_ error: Error) {
    UIAlertController(title: "Sorry", message: error.localizedDescription, preferredStyle: .alert).show(self, sender: nil)
  }
}


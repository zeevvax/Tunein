//
// Created by Zeev Vax on 9/5/21.
//

import Foundation
import UIKit

class CollectionViewController: UIViewController {
  @IBOutlet weak var collectionViewOne: UICollectionView!
  @IBOutlet weak var collectionViewTwo: UICollectionView!
  @IBOutlet weak var collectionViewThree: UICollectionView!
  @IBOutlet weak var containerOne: UIView!
  @IBOutlet weak var containerTwo: UIView!
  @IBOutlet weak var containerThree: UIView!
  @IBOutlet weak var headerOne: UILabel!
  @IBOutlet weak var headerTwo: UILabel!
  @IBOutlet weak var headerThree: UILabel!
  @IBOutlet weak var seeAllButtonOne: UIButton!
  @IBOutlet weak var seeAllButtonTwo: UIButton!
  @IBOutlet weak var seeAllButtonThree: UIButton!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  
  static private let maxElementToShow = 5
  private var dataSource: DataSource?
  private var delegate: ChildViewControllerDelegate?
  private var childrenList = [TuneElement]()

  static func create(dataSource: DataSource, delegate: ChildViewControllerDelegate?) -> CollectionViewController {
    let vc = create(storyboardName: "Main") as! CollectionViewController
    vc.dataSource = dataSource
    vc.delegate = delegate
    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let list = dataSource?.elementList {
      childrenList = list
    }
    configureViews()
  }



  @IBAction func seeAllButtonTapped(_ sender: UIButton) {
    guard let elements = tuneElement(index: sender.tag)?.children else { return }

    if let delegate = delegate {
      delegate.openListView(entry: elements)
    } else {
      let vc = ListViewController.create(elementList: elements, delegate: nil)
      navigationController?.pushViewController(vc, animated: true)
    }
  }

  private func configureViews() {
    if let child = tuneElement(index: 0) {
      headerOne.text = child.text
      seeAllButtonOne.isHidden = false
    } else {
      headerOne.text = nil
      seeAllButtonOne.isHidden = true
    }

    if let child = tuneElement(index: 1) {
      headerTwo.text = child.text
      seeAllButtonTwo.isHidden = false
    } else {
      headerTwo.text = nil
      seeAllButtonTwo.isHidden = true
    }

    if let child = tuneElement(index: 2) {
      headerThree.text = child.text
      seeAllButtonThree.isHidden = false
    } else {
      headerThree.text = nil
      seeAllButtonThree.isHidden = true
    }
  }

  private func handleError(_ error: Error) {
    UIAlertController(title: "Sorry", message: error.localizedDescription, preferredStyle: .alert).show(self, sender: nil)
  }

  private func tuneElement(index: Int) -> TuneElement? {
    guard index >= 0 && index < childrenList.count else { return nil }
    return childrenList[index]
  }
}

extension CollectionViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let children = tuneElement(index: collectionView.tag)?.children {
      return min(children.count, CollectionViewController.maxElementToShow)
    }
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EntryCollectionViewCell", for: indexPath) as! EntryCollectionViewCell
    if let children = tuneElement(index: collectionView.tag)?.children {
      cell.setUp(tuneEntry: children[indexPath.row])
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    if let child = tuneElement(index: collectionView.tag)?.children?[indexPath.row] {
      if child.type == .link {
        if let path = child.path {
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
            case .failure (let error):
              self.handleError(error)
            }
          }
        } else {
          handleError("URL path is missing")
        }
      } else if let path = child.path {
        if let delegate = delegate {
          delegate.presentMessage(message: path)
        } else {
          present(MessageViewController.create(message: path), animated: true)
        }
//        AudioPlayer.shared.playAudio(path: path)
      }
    }
  }
}

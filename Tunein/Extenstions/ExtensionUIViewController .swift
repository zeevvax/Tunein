//
//  ExtensionUIViewController .swift
//  Tunein
//
//  Created by Zeev Vax on 9/4/21.
//

import UIKit

extension UIViewController {
  func addVC(_ child: UIViewController, frame: CGRect? = nil) {
    addChild(child)

    if let frame = frame {
      child.view.frame = frame
    } else {
      child.view.frame = view.bounds
    }

    view.addSubview(child.view)
    child.didMove(toParent: self)
  }

  func removeVC() {
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }

  func topMostViewController() -> UIViewController? {
    if presentedViewController == nil {
      return self
    }
    if let navigation = presentedViewController as? UINavigationController, let visibleViewController = navigation.visibleViewController {
      return visibleViewController.topMostViewController()
    }
    if let tab = presentedViewController as? UITabBarController {
      if let selectedTab = tab.selectedViewController {
        return selectedTab.topMostViewController()
      }
      return tab.topMostViewController()
    }
    return presentedViewController?.topMostViewController()
  }

  class func createInitial(storyboardName: String) -> UIViewController? {
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    return storyboard.instantiateInitialViewController()
  }

  class func create(storyboardName: String) -> UIViewController {
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self))
    return vc
  }
}


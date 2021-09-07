//
// Created by Zeev Vax on 9/5/21.
//

import Foundation
import UIKit

extension UIApplication {
  func topMostViewController() -> UIViewController? {
    keyWindow?.rootViewController?.topMostViewController()
  }
}
//
// Created by Zeev Vax on 9/5/21.
//

import Foundation

extension String: Error {

}

extension Result where Success == Void {
  static var success: Result {
    .success(())
  }
}
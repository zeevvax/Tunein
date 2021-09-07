//
// Created by Zeev Vax on 9/5/21.
//

import Foundation
import Alamofire
import UIKit

import UIKit

class APIHandler {
  static let shared = APIHandler()
  static private let jsonParam = ["render": "json"]
  init() {
    let _ = NetworkReachabilityManager.default?.startListening { status in
      if status == .notReachable {
        let alert = UIAlertController(title: "Sorry", message: "No network connection", preferredStyle: .alert)
        if let vc = UIApplication.shared.topMostViewController() {
          alert.show(vc , sender: nil)
        }
      }
    }
  }

  func getRequest(path: String, completion:@escaping (Result<[AnyHashable: Any], Error>) -> Void ) {
    guard let url = path.httpsURL() else {
      completion(.failure("Can't form URL"))
      return
    }

    AF.request(url, method: .get, parameters: Self.jsonParam).validate().responseJSON { response in
      switch response.result {
      case .success(let data):
        if let value = data as? [AnyHashable: Any] {
          completion(.success(value))
        } else {
          completion(.failure("Bad data received"))
        }

      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
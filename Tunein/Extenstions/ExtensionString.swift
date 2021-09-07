//
// Created by Zeev Vax on 9/6/21.
//

import Foundation

extension String {
  func httpsURL() -> URL? {
    var urlComponents = URLComponents(string:self)
    if let schema = urlComponents?.scheme, schema == "http" {
      urlComponents?.scheme = "https"
    }

    return urlComponents?.url
  }
}
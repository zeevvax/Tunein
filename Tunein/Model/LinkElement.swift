//
// Created by Zeev Vax on 9/4/21.
//

import Foundation

struct LinkElement: TuneElement {
  var type: ElementType = .link
  var text: String
  var path: String?
  var details: String?

  init?(_ entry: Any?) {
    guard let dictionary = entry as? [AnyHashable: Any], let text = dictionary.stringValue(key: "text"),
          let path = dictionary.stringValue(key: "URL") else {
      return nil
    }
    self.text = text
    self.path = path
    details = dictionary.stringValue(key: "subtext")
  }
}
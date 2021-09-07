//
// Created by Zeev Vax on 9/4/21.
//

import Foundation

struct ChildrenElement: TuneElement {
  var type: ElementType = .children
  var text: String
  var path: String?
  var children: [TuneElement]?

  init?(_ entry: Any?) {
    guard let dictionary = entry as? [AnyHashable: Any], let text = dictionary.stringValue(key: "text"),
          let jsonElements = dictionary.arrayValue(key: "children") else {
      return nil
    }
    self.text = text
    let tuneElements = jsonElements.compactMap { dictionary -> TuneElement? in
      guard let dictionary = dictionary as? [AnyHashable: Any], let type = ElementType(dictionary) else { return nil }

      switch type {
      case .link: return LinkElement(dictionary)
      case .audio: return AudioElement(dictionary)
      case .children: return ChildrenElement(dictionary)
      }
    }

    if tuneElements.isEmpty {
      return nil
    }
    children = tuneElements
  }
}
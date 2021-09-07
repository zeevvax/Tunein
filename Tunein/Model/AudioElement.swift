//
// Created by Zeev Vax on 9/4/21.
//

import Foundation

struct AudioElement: TuneElement {
  var type: ElementType = .audio
  var text: String
  var path: String?
  var duration: Int?
  var reliability: Int?
  var imageUrlString: String?
  var details: String?
  var isDownload: Bool = false

  init?(_ entry: Any?) {
    guard let dictionary = entry as? [AnyHashable: Any], let text = dictionary.stringValue(key: "text"), let path = dictionary.stringValue(key: "URL") else {
      return nil
    }
    self.text = text
    self.path = path
    duration = dictionary.intValue(key: "topic_duration")
    reliability = dictionary.intValue(key: "reliability")
    imageUrlString = dictionary.stringValue(key: "image")
    details = dictionary.stringValue(key: "subtext")
    if let streamType = dictionary.stringValue(key: "stream_type") {
      isDownload = (streamType == "download")
    }
  }
}

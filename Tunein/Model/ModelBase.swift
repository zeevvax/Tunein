//
//  File.swift
//  Tunein
//
//  Created by Zeev Vax on 9/4/21.
//

import Foundation

enum ElementType {
  case link
  case children
  case audio
  
  func isPlayable() -> Bool {
    self == .audio
  }

  init?(_ entry: Any?) {
    guard let dictionary = entry as? [AnyHashable: Any] else { return nil }
    var typeString: String?

    if let string = dictionary.stringValue(key: "type") {
      typeString = string
    } else if let _ = dictionary["children"] {
      typeString = "children"
    }

    guard let string = typeString else {
      return nil
    }

    switch string {
    case "link"     : self = .link
    case "children" : self = .children
    case "audio"    : self = .audio
    default         : return nil
    }
  }
}

protocol TuneElement {
  var type: ElementType { get }
  var text: String { get }
  var path: String? { get }
  var children: [TuneElement]? { get }
  var duration: Int? { get }
  var reliability: Int? { get }
  var imageUrlString: String? { get }
  var details: String? { get }
  var isDownload: Bool? { get }
}

extension TuneElement {
  var children: [TuneElement]? { nil }
  var duration: Int? { nil }
  var reliability: Int? { nil }
  var imageUrlString: String? { nil }
  var details: String? { nil }
  var isDownload: Bool? { nil }
}

struct TuneResponse {
  let title: String?
  let status: Double
  let body: [Any]?
  var type: ElementType? {
    if let firstElement = body?.first, let elementType = ElementType(firstElement) {
      return elementType
    }
    return nil
  }

  init(_ dictionary: [AnyHashable: Any]?) {
    guard let head = dictionary?.jsonDictionaryValue(key: "head"), let codeString = head.stringValue(key: "status"), let  code = Double(codeString) else {
      status = 400
      title = nil
      body = nil
      return
    }
    status = code
    title = head.stringValue(key: "title")
    body = dictionary?.arrayValue(key: "body")
  }
}
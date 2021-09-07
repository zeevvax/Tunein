//
//  ExtensionDictionary .swift
//  Tunein
//
//  Created by Zeev Vax on 9/4/21.
//

import Foundation

extension Dictionary {
  var json: String {
    let invalidJson = "Not a valid JSON"
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
      return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
    } catch {
      return invalidJson
    }
  }

  func intValue(key: Key, defaultValue: Int? = nil) -> Int? {
    if let value = self[key] as? Int {
      return value
    }
    return defaultValue
  }

  func int64Value(key: Key, defaultValue: Int64? = nil) -> Int64? {
    if let value = self[key] as? Int64 {
      return value
    }
    return defaultValue
  }

  func doubleValue(key: Key, defaultValue: Double? = nil) -> Double? {
    if let value = self[key] as? Double {
      return value
    }
    return defaultValue
  }

  func stringValue(key: Key, defaultValue: String? = nil) -> String? {
    if let value = self[key] as? String {
      return value
    }
    return defaultValue
  }

  func boolValue(key: Key, defaultValue: Bool? = nil) -> Bool? {
    if let value = self[key] as? Bool {
      return value
    }
    return defaultValue
  }

  func jsonDictionaryValue(key: Key, defaultValue: Dictionary? = nil) -> [AnyHashable: Any]? {
    if let value = self[key] as? [AnyHashable: Any] {
      return value
    }
    return defaultValue
  }

  func arrayValue(key: Key, defaultValue: [Any]? = nil) -> [Any]? {
    if let value = self[key] as? [Any] {
      return value
    }
    return defaultValue
  }

//
//    func arrayDictionary(key: Key) -> [Dictionary]? {
//      if let value = self[key] as? [Dictionary] {
//        return value
//      }
//      return nil
//    }

  func mergeKeepingCurrent(otherDictionary: [Key: Value]) -> [Key: Value] {
    self.merging(otherDictionary) { current, _ in current }
  }

  func mergeKeepingNew(otherDictionary: [Key: Value]) -> [Key: Value] {
    self.merging(otherDictionary) { _, new in new }
  }
}

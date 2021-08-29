//
//  KeyMapper.swift
//  MARU
//
//  Created by psychehose on 2021/08/29.
//
struct AnyKey: CodingKey {
  var stringValue: String
  var intValue: Int?
  init(stringValue: String) {
    self.stringValue = stringValue
  }
  init?(intValue: Int) {
    self.stringValue = String(intValue)
    self.intValue = intValue
  }
}
extension KeyedDecodingContainer where K == AnyKey {
  func decode<T>(_ type: T.Type,
                 forMappedKey key: String,
                 in keyMap: [String: [String]]) throws -> T where T: Decodable {
    for key in keyMap[key] ?? [] {
      if let value = try? decode(T.self, forKey: AnyKey(stringValue: key)) {
        return value
      }
    }
    return try decode(T.self, forKey: AnyKey(stringValue: key))
  }
}

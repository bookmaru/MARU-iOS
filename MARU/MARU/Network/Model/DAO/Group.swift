//
//  Group.swift
//  MARU
//
//  Created by psychehose on 2021/07/15.
//

import Foundation

struct Group: Codable {
  let discussionGroupId: Int
  let description: String
  let createdAt: String
  let title: String
  let remainingDay: Int
  let image: String
  let author: String
  let nickname: String
}
struct Groups: Codable {
  let groups: [Group]

  init(from decoder: Decoder) throws {
    let keyMap = [
      "groups": ["groups", "groupsByCategory"]
    ]
    let container = try decoder.container(keyedBy: AnyKey.self)
    self.groups = try container.decode([Group].self, forMappedKey: "groups", in: keyMap)
  }
}

struct GroupsByCategory: Codable {
  let category: String
  let groups: [Group]
}

struct GroupsByCategories: Codable {
  let groupsByCategory: [GroupsByCategory]
}

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

//
//  Group.swift
//  MARU
//
//  Created by psychehose on 2021/07/15.
//

import Foundation

struct Group: Codable {
  let discussionGroupID: Int
  let description: String
  let createdAt: String
  let title: String
  let remainingDay: Int
  let image: String
  let author: String
  let nickname: String

  enum CodingKeys: String, CodingKey {
    case discussionGroupID = "discussionGroupId"
    case description
    case createdAt
    case title
    case remainingDay
    case image
    case author
    case nickname
  }
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

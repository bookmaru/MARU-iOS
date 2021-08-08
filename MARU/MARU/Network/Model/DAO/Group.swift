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
}

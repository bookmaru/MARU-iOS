//
//  NewMeetingModel.swift
//  MARU
//
//  Created by psychehose on 2021/07/15.
//

import Foundation

struct MeetingModel: Hashable, Equatable {
  let discussionGroupID: Int
  let description: String
  let createdAt: String
  let remainingDay: Int
  let title: String
  let image: String
  let author: String
  let nickname: String
  let category: String

  init(_ group: Group, _ category: String = "") {
    self.discussionGroupID = group.discussionGroupID
    self.description = group.description
    self.createdAt = group.createdAt
    self.remainingDay = group.remainingDay
    self.title = group.title
    self.image = group.image
    self.author = group.author
    self.nickname = group.nickname
    self.category = category
  }

  init(discussionGroupId: Int,
       description: String,
       createdAt: String,
       remainingDay: Int,
       title: String,
       image: String,
       author: String,
       nickname: String,
       category: String) {
    self.discussionGroupID = discussionGroupId
    self.description = description
    self.author = author
    self.createdAt = createdAt
    self.remainingDay = remainingDay
    self.title = title
    self.image = image
    self.nickname = nickname
    self.category = category
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(discussionGroupID)
  }
  static func == (lhs: MeetingModel, rhs: MeetingModel) -> Bool {
    lhs.discussionGroupID == rhs.discussionGroupID
  }
}

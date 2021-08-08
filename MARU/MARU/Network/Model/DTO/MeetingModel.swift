//
//  NewMeetingModel.swift
//  MARU
//
//  Created by psychehose on 2021/07/15.
//

import Foundation

struct MeetingModel: Hashable {
  let discussionGroupId: Int
  let description: String
  let createdAt: String
  let remainingDay: Int
  let title: String
  let image: String
  let author: String
  let nickname: String

  init(_ group: Group) {
    self.discussionGroupId = group.discussionGroupId
    self.description = group.description
    self.createdAt = group.createdAt
    self.remainingDay = group.remainingDay
    self.title = group.title
    self.image = group.image
    self.author = group.author
    self.nickname = group.nickname
  }

  init(discussionGroupId: Int,
       description: String,
       createdAt: String,
       remainingDay: Int,
       title: String,
       image: String,
       author: String,
       nickname: String) {
    self.discussionGroupId = discussionGroupId
    self.description = description
    self.author = author
    self.createdAt = createdAt
    self.remainingDay = remainingDay
    self.title = title
    self.image = image
    self.nickname = nickname
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(discussionGroupId)
  }
  static func == (lhs: MeetingModel, rhs: MeetingModel) -> Bool {
    lhs.discussionGroupId == rhs.discussionGroupId
  }
}

//
//  GroupChat.swift
//  MARU
//
//  Created by 오준현 on 2021/09/17.
//

struct GeneratedGroup {
  let discussionGroupID: Int
  let description: String
  let createdAt: String
  let title: String
  let remainingDay: Int
  let image: String
  let author: String
  let nickname: String
  let message: String

  init(group: Group, message: RealmChat) {
    discussionGroupID = group.discussionGroupID
    description = group.description
    createdAt = group.createdAt
    title = group.title
    remainingDay = group.remainingDay
    image = group.image
    author = group.author
    nickname = group.nickname
    self.message = message.content
  }
}

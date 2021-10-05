//
//  GroupInformation.swift
//  MARU
//
//  Created by 이윤진 on 2021/10/04.
//

struct GroupInformation: Codable {
  let groups: GroupModel?
}

struct GroupModel: Codable {
  let discussionGroupID: Int
  let description: String
  let createdAt: String
  let remainingDay: Int
  let title: String
  let image: String
  let author: String
  let nickname: String
  let leaderScore: Int
  let userCount: Int
  let possibleIntoGroup: Bool
}

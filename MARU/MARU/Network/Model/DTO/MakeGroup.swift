//
//  MakeGroup.swift
//  MARU
//
//  Created by 김호세 on 2021/09/13.
//

import Foundation
struct MakeGroup: Codable {
  let book: MakeBook
  let group: GroupDescription
  let question: Question
}

struct MakeBook: Codable {
  let isbn: String
  let title: String
  let author: String
  let imageUrl: String
  let category: String
}
struct GroupDescription: Codable {
  let isbn: String
  let description: String
}
struct Question: Codable {
  let answer: [String]
  let quiz: [String]
}
struct ResultMakeGroup: Codable {
  let groupID: Int

  enum CodingKeys: String, CodingKey {
    case groupID = "groupId"
  }
}

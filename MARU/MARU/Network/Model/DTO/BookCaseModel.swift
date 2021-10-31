//
//  BookCaseModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/15.
//

struct BookCaseModel: Codable {
  let bookcase: [BookCase]
}

struct BookCase: Codable {
  let bookcaseID: Int
  let isbn: String
  let title: String
  let author: String
  let imageURL: String
}

struct KeepGroupModel: Codable {
  let keepGroup: [KeepGroup]
}

struct KeepGroup: Codable {
  let groupID: Int
  let image: String
  let title: String
  let author: String
  let description: String
  let userID: Int
  let nickname: String
  let leaderScore: Int
  let isLeader: Bool

  enum CodingKeys: String, CodingKey {
    case groupID = "groupId"
    case image
    case title
    case author
    case description
    case userID = "leaderId"
    case nickname
    case leaderScore
    case isLeader = "meLeader"
  }
}

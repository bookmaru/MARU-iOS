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
  let nickName: String
  let leaderScore: Int
  let isLeader: Bool
}

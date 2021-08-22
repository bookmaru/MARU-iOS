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
  let bookcaseId: Int
  let isbn: String
  let title: String
  let author: String
  let imageUrl: String
}

struct KeepGroupModel: Codable {
  let keepGroup: [KeepGroup]
}

struct KeepGroup: Codable {
  let groupId: Int
  let image: String
  let title: String
  let author: String
  let description: String
  let userId: Int
  let nickName: String
  let leaderScore: Int
  let meLeader: Bool
}

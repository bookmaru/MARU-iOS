//
//  MakeGroup.swift
//  MARU
//
//  Created by 김호세 on 2021/09/13.
//

import Foundation
  // MARK: - POST
struct MakeGroup: Codable {
  let book: BookModel
  let group: GroupDescription
  let question: Question
}

struct GroupDescription: Codable {
  let isbn: Int
  let description: String
}
struct Question: Codable {
  let answer: [String]
  let quiz: [String]
}
  // MARK: - GET
struct ResultMakeGroup: Codable {
  let makeGroup: Int
}

//extension MakeGroup {
//  func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: CodingKeys.self)
//    try container.encode(book, forKey: .book)
//    try container.encode(group, forKey: .group)
//    try container.encode(question, forKey: .question)
//  }
//}

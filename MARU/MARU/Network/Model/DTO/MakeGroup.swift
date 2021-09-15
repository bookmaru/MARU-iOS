//
//  MakeGroup.swift
//  MARU
//
//  Created by 김호세 on 2021/09/13.
//

import Foundation
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
struct ResultMakeGroup: Codable {
  let makeGroup: Int
}

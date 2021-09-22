//
//  MainBookModel.swift
//  MARU
//
//  Created by psychehose on 2021/05/08.
//

import Foundation

struct Book: Codable {
  let isbn: Int
  let title: String
  let author: String
  let imageURL: String
  let category: String

  enum CodingKeys: String, CodingKey {
    case isbn
    case title
    case author
    case imageURL = "imageUrl"
    case category
  }
}

struct Books: Codable {
  let books: [Book]
}

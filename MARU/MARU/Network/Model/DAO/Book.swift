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
  let imageUrl: String
  let category: String
}
struct Books: Codable {
  let books: [Book]
}

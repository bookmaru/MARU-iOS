//
//  MainBookModel.swift
//  MARU
//
//  Created by psychehose on 2021/05/08.
//

import Foundation

struct Book: Codable {
  let bookImage: String
  let bookTitle: String
  let bookAuthor: String
  let bookComment: String
  let roomChief: String
  let category: String
}

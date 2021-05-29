//
//  MainBookModel.swift
//  MARU
//
//  Created by psychehose on 2021/05/08.
//

import Foundation

struct Book: Codable {
  var bookImage: String
  var bookTitle: String
  var bookAuthor: String
  var bookComment: String
  var roomChief: String
}

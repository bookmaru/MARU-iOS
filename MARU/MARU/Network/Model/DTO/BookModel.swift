//
//  ViewMain.swift
//  MARU
//
//  Created by psychehose on 2021/05/09.
//

import Foundation

struct BookModel: Hashable, Codable {
  let isbn: Int
  let title: String
  let author: String
  let imageURL: String
  let category: String

  init(_ book: Book) {
    self.isbn = book.isbn
    self.title = book.title
    self.author = book.author
    self.imageURL = book.imageURL
    self.category = book.category
  }
  init(isbn: Int,
       title: String,
       author: String,
       imageURL: String,
       category: String) {
    self.isbn = isbn
    self.title = title
    self.author = author
    self.imageURL = imageURL
    self.category = category
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(isbn)
  }

  static func == (lhs: BookModel, rhs: BookModel) -> Bool {
    lhs.isbn == rhs.isbn
  }
}

extension BookModel {
  static var initMainData: [BookModel] = [
    BookModel.init(Book.init(isbn: 1,
                             title: "test",
                             author: "test",
                             imageURL: "test",
                             category: "test"))
  ]
}

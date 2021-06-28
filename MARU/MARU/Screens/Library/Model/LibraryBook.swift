//
//  LibraryBook.swift
//  MARU
//
//  Created by psychehose on 2021/06/28.
//

import Foundation

struct LibraryBook: Hashable {
  let identifier = UUID()
  let bookImage: String
  let bookTitle: String
  let bookAuthor: String

  init(bookImage: String,
       bookTitle: String,
       bookAuthor: String) {
    self.bookImage = bookImage
    self.bookTitle = bookTitle
    self.bookAuthor = bookAuthor
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  static func == (lhs: LibraryBook, rhs: LibraryBook) -> Bool {
    lhs.identifier == rhs.identifier
  }
}
  // MARK: - 임시데이터 생성
extension LibraryBook {
  static var initData: [LibraryBook] = [
    LibraryBook(bookImage: "",
                bookTitle: "이러지마",
                bookAuthor: "그러지마"),
    LibraryBook(bookImage: "",
                bookTitle: "이러지마1",
                bookAuthor: "그러지마1"),
    LibraryBook(bookImage: "",
                bookTitle: "이러지마2",
                bookAuthor: "그러지마2"),
    LibraryBook(bookImage: "",
                bookTitle: "이러지마3",
                bookAuthor: "그러지마3"),
    LibraryBook(bookImage: "",
                bookTitle: "이러지마4",
                bookAuthor: "그러지마4"),
    LibraryBook(bookImage: "",
                bookTitle: "이러지마5",
                bookAuthor: "그러지마5")
  ]
}

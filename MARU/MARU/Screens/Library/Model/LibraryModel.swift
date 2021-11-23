//
//  LibraryModel.swift
//  MARU
//
//  Created by psychehose on 2021/06/28.
//

import Foundation

struct LibraryModel: Hashable {
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

  static func == (lhs: LibraryModel, rhs: LibraryModel) -> Bool {
    lhs.identifier == rhs.identifier
  }
}

// 이거 삭제하고 처리해주세요 :pray: @psychehose
  // MARK: - 임시데이터 생성
extension LibraryModel {
  static var initData: [LibraryModel] = [
    LibraryModel(bookImage: "",
                bookTitle: "이러지마",
                bookAuthor: "그러지마"),
    LibraryModel(bookImage: "",
                bookTitle: "이러지마1",
                bookAuthor: "그러지마1"),
    LibraryModel(bookImage: "",
                bookTitle: "이러지마2",
                bookAuthor: "그러지마2"),
    LibraryModel(bookImage: "",
                bookTitle: "이러지마3",
                bookAuthor: "그러지마3"),
    LibraryModel(bookImage: "",
                bookTitle: "이러지마4",
                bookAuthor: "그러지마4"),
    LibraryModel(bookImage: "",
                bookTitle: "이러지마5",
                bookAuthor: "그러지마5")
  ]
  static var initData2: [LibraryModel] = [
    LibraryModel(bookImage: "",
                bookTitle: "이러지마",
                bookAuthor: "그러지마"),
    LibraryModel(bookImage: "",
                bookTitle: "이러지마1",
                bookAuthor: "그러지마1"),
    LibraryModel(bookImage: "",
                bookTitle: "이러지마2",
                bookAuthor: "그러지마2"),
    LibraryModel(bookImage: "",
                bookTitle: "이러지마3",
                bookAuthor: "그러지마3"),
    LibraryModel(bookImage: "",
                bookTitle: "이러지마4",
                bookAuthor: "그러지마4"),
    LibraryModel(bookImage: "",
                bookTitle: "이러지마5",
                bookAuthor: "그러지마5")
  ]
}

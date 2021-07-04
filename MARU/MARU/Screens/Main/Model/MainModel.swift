//
//  ViewMain.swift
//  MARU
//
//  Created by psychehose on 2021/05/09.
//

import Foundation

struct MainModel: Hashable {

  let identifier = UUID()
  var book: Book

  init(book: Book) {
    self.book = book
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  static func == (lhs: MainModel, rhs: MainModel) -> Bool {
    lhs.identifier == rhs.identifier
  }
}

extension MainModel {
  static var initMainData: [MainModel] = [
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "B",
                                   bookAuthor: "B",
                                   bookComment: "B",
                                   roomChief: "B",
                                   category: 2)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "B",
                                   bookAuthor: "B",
                                   bookComment: "B",
                                   roomChief: "B",
                                   category: 2)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3))
  ]
}

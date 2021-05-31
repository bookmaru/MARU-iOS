//
//  ViewMain.swift
//  MARU
//
//  Created by psychehose on 2021/05/09.
//

import Foundation

struct ViewMain {
  var bookImage: String
  var bookTitle: String
  var bookAuthor: String
  var bookComment: String
  var roomChief: String

  init(_ item: Book) {
    bookImage = item.bookImage
    bookTitle = item.bookTitle
    bookAuthor = item.bookAuthor
    bookComment = item.bookComment
    roomChief = item.roomChief
  }
  init(bookImage: String,
       bookTitle: String,
       bookAuthor: String,
       bookComment: String,
       roomChief: String ) {
    self.bookImage = bookImage
    self.bookTitle = bookTitle
    self.bookAuthor = bookAuthor
    self.bookComment = bookComment
    self.roomChief = roomChief
  }
}

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

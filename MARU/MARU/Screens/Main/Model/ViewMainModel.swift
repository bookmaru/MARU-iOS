//
//  ViewMain.swift
//  MARU
//
//  Created by psychehose on 2021/05/09.
//

import Foundation

struct ViewMainModel: Hashable {

  let identifier = UUID()
  var book: Book
  
  init(book: Book) {
    self.book = book
  }
  func hash(into hasher: inout Hasher) {
    // 2
    hasher.combine(identifier)
  }
  static func == (lhs: ViewMainModel, rhs: ViewMainModel) -> Bool {
    lhs.identifier == rhs.identifier
  }
}

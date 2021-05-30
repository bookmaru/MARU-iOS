//
//  ViewMain.swift
//  MARU
//
//  Created by psychehose on 2021/05/09.
//

import Foundation

struct ViewMainModel: Hashable {
  
  var id = UUID()
  var book: Book
  
  init(book: Book) {
    self.book = book
  }
  func hash(into hasher: inout Hasher) {
    // 2
    hasher.combine(id)
  }
  static func == (lhs: ViewMainModel, rhs: ViewMainModel) -> Bool {
    lhs.id == rhs.id
  }
}

extension ViewMainModel {
    func generateMainModel() -> [ViewMainModel] {
    
      var viewMainModel = [ViewMainModel]()
      
      viewMainModel.append(contentsOf: [
        ViewMainModel.init(book: Book.init(bookImage: "", bookTitle: "A", bookAuthor: "A", bookComment: "A", roomChief: "A", category: "A1")),
        ViewMainModel.init(book: Book.init(bookImage: "", bookTitle: "B", bookAuthor: "B", bookComment: "B", roomChief: "B", category: "B2")),
        ViewMainModel.init(book: Book.init(bookImage: "", bookTitle: "C", bookAuthor: "C", bookComment: "C", roomChief: "C", category: "C3"))
      ])
      return viewMainModel
    }
}


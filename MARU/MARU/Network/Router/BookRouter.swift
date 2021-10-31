//
//  BookRouter.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import Moya

enum BookRouter {
  case get
  case group
  case addGroup(groupID: Int)
  case addBook(author: String, category: String, imageURL: String, isbn: Int, title: String)
}

extension BookRouter: BaseTargetType {
  var path: String {
    switch self {
    case .get: // 담아둔 모임
      return "bookcase"
    case .group: // 모임하고 싶은 책
      return "bookcase/group"
    case .addGroup(let groupID):
      return "bookcase/group/\(groupID)"
    case .addBook:
      return "bookcase"
    }
  }

  var method: Method {
    switch self {
    case .get:
      return .get
    case .group:
      return .get
    case .addGroup:
      return .post
    case .addBook:
      return .post
    }
  }

  var task: Task {
    switch self {
    case .get:
      return .requestPlain
    case .group:
      return .requestPlain
    case .addGroup:
      return .requestPlain
    case let .addBook(author,category,imageURL,isbn,title):
      let parameter: [String: Any] = [
        "author": author,
        "category": category,
        "imageURL": imageURL,
        "isbn": isbn,
        "title": title
      ]
      return .requestParameters(parameters: parameter, encoding: JSONEncoding.default)
    }
  }
}

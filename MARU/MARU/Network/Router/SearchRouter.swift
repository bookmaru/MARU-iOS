//
//  SearchRouter.swift
//  MARU
//
//  Created by psychehose on 2021/07/28.
//

import Moya

enum SearchRouter {
  case search(queryString: String)
  case bookSearch(queryString: String, page: Int)
  case meetingSearchByISBN(isbn: String, page: Int)
}

extension SearchRouter: TargetType {
  var baseURL: URL {
    return Enviroment.baseURL
  }
  var path: String {
    switch self {
    case .search:
      return "group/search/"
    case .bookSearch:
      return "book/search/library/"
    case .meetingSearchByISBN:
      return "group/book"
    }
  }

  var method: Method {
    switch self {
    case .search:
      return .get
    case .bookSearch:
      return .get
    case .meetingSearchByISBN:
      return .get
    }
  }

  var sampleData: Data { Data() }

  var task: Task {
    switch self {
    case let .search(queryString):
      return .requestParameters(
        parameters: ["title": queryString],
        encoding: URLEncoding.queryString
      )
    case let .bookSearch(queryString, page):
      return .requestParameters(
        parameters: [
          "title": queryString,
          "page": page
        ],
        encoding: URLEncoding.queryString
      )
    case let .meetingSearchByISBN(isbn, page):
      return .requestParameters(
        parameters: [
          "isbn": isbn,
          "page": page
        ],
        encoding: URLEncoding.queryString
      )
    }
  }
  var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }
}

//
//  SearchRouter.swift
//  MARU
//
//  Created by psychehose on 2021/07/28.
//

import Moya

enum SearchRouter {
  case search(queryString: String)
}

extension SearchRouter: TargetType {
  var baseURL: URL {
    return URL(string: "http://3.36.251.65:8080")!
  }
  var path: String {
    switch self {
    case .search:
      return "api/v2/book/search/"
    }
  }

  var method: Method {
    switch self {
    case .search:
      return .get
    }
  }

  var sampleData: Data { Data() }

  var task: Task {
    switch self {
    case let .search(queryString):
      return .requestParameters(parameters: [ "title": queryString],
                                encoding: URLEncoding.queryString)
    }
  }
  var headers: [String: String]? {
    return ["Content-Type": "aplication/json"]
  }
}

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
    return Enviroment.baseURL
  }
  var path: String {
    switch self {
    case .search:
      return "group/search/"
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
      return .requestParameters(parameters: ["title": queryString],
                                encoding: URLEncoding.queryString)
    }
  }
  var headers: [String: String]? {
    return ["Content-Type": "aplication/json"]
  }
}

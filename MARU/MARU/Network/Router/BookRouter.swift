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
}

extension BookRouter: TargetType {
  var baseURL: URL {
    return URL(string: "http://3.36.251.65:8080")!
  }
  var path: String {
    switch self {
    case .get:
      return "/api/v2/bookcase"
    case .group:
      return "/api/v2/diary"
    }
  }

  var method: Method {
    switch self {
    case .get:
      return .get
    case .group:
      return .get
    }
  }

  var sampleData: Data { Data() }

  var task: Task {
    switch self {
    case .get:
      return .requestPlain
    case .group:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    return ["Content-Type": "aplication/json"]
  }
}

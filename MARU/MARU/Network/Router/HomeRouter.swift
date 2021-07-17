//
//  HomeRouter.swift
//  MARU
//
//  Created by psychehose on 2021/07/09.
//

import Moya

enum HomeRouter {
  case getPopular
  case getNew
}

extension HomeRouter: TargetType {
  var baseURL: URL {
    return URL(string: "http://3.36.251.65:8080")!
  }
  var path: String {
    switch self {
    case .getPopular:
      return "api/v2/book/group/most"
    case .getNew:
      return "api/v2/group/new"
    }
  }

  var method: Method {
    switch self {
    case .getPopular:
      return .get
    case .getNew:
      return .get
    }
  }

  var sampleData: Data { Data() }

  var task: Task {
    switch self {
    case .getPopular:
      return .requestPlain
    case .getNew:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    return ["Content-Type": "aplication/json"]
  }
}

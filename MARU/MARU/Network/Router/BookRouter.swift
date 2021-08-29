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
    return Enviroment.baseURL
  }
  var path: String {
    switch self {
    case .get: // 담아둔 모임
      return "/api/v2/bookcase"
    case .group: // 모임하고 싶은 책
      return "/api/v2/bookcase/group"
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
    return [
      "Content-Type": "aplication/json",
      "accessToken": KeychainHandler.shared.accessToken
    ]
  }
}

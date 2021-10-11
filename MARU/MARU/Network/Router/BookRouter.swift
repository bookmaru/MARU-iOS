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
}

extension BookRouter: TargetType {
  var baseURL: URL {
    return Enviroment.baseURL
  }
  var path: String {
    switch self {
    case .get: // 담아둔 모임
      return "bookcase"
    case .group: // 모임하고 싶은 책
      return "bookcase/group"
    case .addGroup(let groupID):
      return "bookcase/group/\(groupID)"
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
    }
  }
  var sampleData: Data { Data() }
  var task: Task {
    switch self {
    case .get:
      return .requestPlain
    case .group:
      return .requestPlain
    case .addGroup:
      return .requestPlain
    }
  }
  var headers: [String: String]? {
    return [
      "Content-Type": "application/json",
      "accessToken": KeychainHandler.shared.accessToken
    ]
  }
}

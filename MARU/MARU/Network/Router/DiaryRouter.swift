//
//  DiaryRouter.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import Moya

enum DiaryRouter {
  case list
  case post
  case get
  case edit
  case delete
}

extension DiaryRouter: TargetType {
  var baseURL: URL {
    return URL(string: "http://3.36.251.65:8080")!
  }
  var path: String {
    switch self {
    case .list:
      return "/api/v2/diary"
    case .post:
      return "/api/v2/diary"
    case .get:
      return "/api/v2/diary"
    case .edit:
      return "/api/v2/diary"
    case .delete:
      return "/api/v2/diary"
    }
  }

  var method: Method {
    switch self {
    case .list:
      return .get
    case .post:
      return .post
    case .get:
      return .get
    case .edit:
      return .put
    case .delete:
      return .delete
    }
  }

  var sampleData: Data { Data() }

  var task: Task {
    switch self {
    case .list:
      return .requestPlain
    case .post:
      return .requestPlain
    case .get:
      return .requestPlain
    case .edit:
      return .requestPlain
    case .delete:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    return ["Content-Type": "aplication/json"]
  }
}

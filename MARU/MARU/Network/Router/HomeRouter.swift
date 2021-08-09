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
  case getNewAllCategory
  case getNewCategory(String, Int)
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
    case .getNewAllCategory:
      return "api/v2/group/new/category"
    case .getNewCategory(_, _):
      return "api/v2/group/new/specific-category"
    }
  }

  var method: Method {
    switch self {
    case .getPopular:
      return .get
    case .getNew:
      return .get
    case .getNewAllCategory:
      return .get
    case .getNewCategory:
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
    case .getNewAllCategory:
      return .requestPlain
    case .getNewCategory(let category, let currentGroupCount):
      return .requestParameters(
        parameters: [
          "category": category,
          "currentGroupCount": currentGroupCount
        ],
        encoding: URLEncoding.queryString
      )
    }
  }
  var headers: [String: String]? {
    return ["Content-Type": "aplication/json"]
  }
}

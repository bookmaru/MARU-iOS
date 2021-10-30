//
//  HomeRouter.swift
//  MARU
//
//  Created by psychehose on 2021/07/09.
//

import Moya

enum HomeRouter {
  case getPopular
  case getNew(page: Int)
  case getNewAllCategory
  case getNewCategory(category: String, currentGroupCount: Int)
}

extension HomeRouter: BaseTargetType {
  var path: String {
    switch self {
    case .getPopular:
      return "book/group/most"
    case .getNew:
      return "group/new"
    case .getNewAllCategory:
      return "group/new/category"
    case .getNewCategory(_, _):
      return "group/new/specific-category"
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

  var task: Task {
    switch self {
    case .getPopular:
      return .requestPlain
    case .getNew(let page):
      return .requestParameters(
        parameters: [
          "page": page
        ],
        encoding: URLEncoding.queryString
      )
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
}

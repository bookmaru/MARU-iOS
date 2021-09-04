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
  case get(diaryId: Int)
  case edit(diaryId: Int)
  case delete(diaryId: Int)
}

extension DiaryRouter: TargetType {
  var baseURL: URL {
    return Enviroment.baseURL
  }
  var path: String {
    switch self {
    case .list:
      return "diary"
    case .post:
      return "diary"
    case .get(let diaryId):
      return "diary/\(diaryId)"
    case .edit(let diaryId):
      return "diary/\(diaryId)"
    case .delete(let diaryId):
      return "diary/\(diaryId)"
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
    return [
      "Content-Type": "aplication/json",
      "accessToken": KeychainHandler.shared.accessToken
    ]
  }
}

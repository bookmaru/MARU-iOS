//
//  DiaryRouter.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import Moya

enum DiaryRouter {
  case list
  case post(groupID: Int, title: String, content: String)
  case get(diaryID: Int)
  case edit(diaryID: Int, title: String, content: String)
  case delete(diaryID: Int)
}

extension DiaryRouter: BaseTargetType {
  var path: String {
    switch self {
    case .list:
      return "diary"
    case .post:
      return "diary"
    case .get(let diaryID):
      return "diary/\(diaryID)"
    case .edit(let diaryId, _, _):
      return "diary/\(diaryId)"
    case .delete(let diaryID):
      return "diary/\(diaryID)"
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

  var task: Task {
    switch self {
    case .list:
      return .requestPlain
    case let .post(groupID, title, content):
      let parameter: [String: Any] = [
        "discussionGroupId": groupID,
        "title": title,
        "content": content
      ]
      return .requestParameters(parameters: parameter, encoding: JSONEncoding.default)
    case .get:
      return .requestPlain
    case let .edit(_, title, content):
      let parameter: [String: Any] = [
        "title": title,
        "content": content
      ]
      return .requestParameters(parameters: parameter, encoding: JSONEncoding.default)
    case .delete:
      return .requestPlain
    }
  }
}

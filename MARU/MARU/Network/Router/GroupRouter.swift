//
//  GroupRouter.swift
//  MARU
//
//  Created by 오준현 on 2021/08/24.
//

import Moya

enum GroupRouter {
  case participate
  case chatList(roomID: Int)
  case diaryList
  case groupInfo(groupID: Int)
  case keep(groupID: Int)
  case evaluate(groupID: Int, leaderID: Int, score: Int)
}

extension GroupRouter: TargetType {
  var baseURL: URL {
    switch self {
    case .chatList:
      let url = URL(string: "http://3.36.251.65:8082/")!
      return url
    default:
      return Enviroment.baseURL
    }
  }
  var path: String {
    switch self {
    case .participate:
      return "group/doing"
    case .chatList(let roomID):
      return "chat/group/\(roomID)"
    case .diaryList:
      return "group/diary"
    case .groupInfo(let groupID):
      return "group/\(groupID)/intro"
    case .keep(let groupID):
      return "group/\(groupID)/keep"
    case .evaluate(let groupID, let leaderID, let score):
      return "group/\(groupID)/leader/\(leaderID)"
    }
  }

  var method: Method {
    switch self {
    case .evaluate:
      return .post
    default:
      return .get
    }
  }

  var sampleData: Data { Data() }

  var task: Task {
    switch self {
    case let .evaluate(groupID, leaderID, score):
      return .requestParameters(
        parameters: [
          "groupId": groupID,
          "leaderId": leaderID,
          "score": score
        ],
        encoding: URLEncoding.queryString
      )
    default:
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

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

extension GroupRouter: BaseTargetType {

  var baseURL: URL {
    switch self {
    case .chatList:
      let url = URL(string: "http://3.36.250.26:8082/")!
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
    case .evaluate(let groupID, let leaderID, _):
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

  var task: Task {
    switch self {
    case let .evaluate(_, _, score):
      return .requestParameters(
        parameters: [
          "score": score
        ],
        encoding: URLEncoding.queryString
      )
    default:
      return .requestPlain
    }
  }
}

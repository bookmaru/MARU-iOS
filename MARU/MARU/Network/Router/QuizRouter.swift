//
//  QuizRouter.swift
//  MARU
//
//  Created by psychehose on 2021/08/21.
//

import Moya

enum QuizRouter {
  case getQuiz(groupID: Int)
  case checkQuiz(groupID: Int, isEnter: String)
}

extension QuizRouter: TargetType {
  var baseURL: URL {
    return URL(string: "http://3.36.251.65:8080")!
  }
  var path: String {
    switch self {
    case .getQuiz(let groupID):
      return "api/v2/group/\(groupID)/quiz"
    case .checkQuiz(let groupID, let isEnter):
      return "api/v2/group/\(groupID)/quiz/\(isEnter)"
    }
  }

  var method: Method {
    switch self {
    case .getQuiz:
      return .get
    case .checkQuiz:
      return .post
    }
  }

  var sampleData: Data { Data() }

  var task: Task {
    switch self {
    case .getQuiz(_):
      return .requestPlain
    case .checkQuiz(_, _):
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

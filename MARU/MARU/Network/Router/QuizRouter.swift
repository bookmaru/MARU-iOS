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
    return Enviroment.baseURL
  }
  var path: String {
    switch self {
    case .getQuiz(let groupID):
      return "group/\(groupID)/quiz"
    case .checkQuiz(let groupID, let isEnter):
      return "group/\(groupID)/quiz/\(isEnter)"
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
    case .getQuiz:
      return .requestPlain
    case .checkQuiz:
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

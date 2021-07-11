//
//  AuthRouter.swift
//  MARU
//
//  Created by 오준현 on 2021/06/25.
//

import Moya

enum AuthType {
  case kakao
  case apple

  var description: String {
    switch self {
    case .apple:
      return "apple"
    case .kakao:
      return "kakao"
    }
  }
}

enum AuthRouter {
  case auth(type: AuthType, token: String)
  case nicknameCheck(String)
  case information(information: UserInformation)
}

extension AuthRouter: TargetType {
  var baseURL: URL {
    return URL(string: "http://3.36.251.65:8080")!
  }

  var path: String {
    switch self {
    case .auth(let type, _):
      return "/api/v2/login/\(type.description)"
    case .nicknameCheck(let nickname):
      return "/api/v2/nickname/check/\(nickname)"
    case .information:
      return "/api/v2/signup"
    }
  }

  var method: Method {
    switch self {
    case .auth, .information:
      return .post
    case .nicknameCheck:
      return .get
    }
  }

  var sampleData: Data { Data() }

  var task: Task {
    switch self {
    case let .information(information):
      var body: [String: Any] = [:]
      if let birth = information.birth {
        body["birth"] = birth
      }
      if let gender = information.gender {
        body["gender"] = gender
      }
      body["nickname"] = information.nickname
      return .requestCompositeParameters(
        bodyParameters: body,
        bodyEncoding: JSONEncoding.default,
        urlParameters: .init())
    default:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    switch self {
    case let .auth(_, token):
      return [
        "Content-Type": "application/json",
        "accessToken": token
      ]
    default:
      return [
        "Content-Type": "application/json",
        "accessToken": KeychainHandler.shared.accessToken
      ]
    }
  }
}

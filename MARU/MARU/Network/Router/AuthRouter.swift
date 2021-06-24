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
      return "APPLE"
    case .kakao:
      return "KAKAO"
    }
  }
}

enum AuthRouter {
  case auth(type: AuthType, token: String)
  case nicknameCheck(String)
}

extension AuthRouter: TargetType {
  var baseURL: URL {
    return URL(string: "http://3.36.251.65:8080")!
  }

  var path: String {
    switch self {
    case .auth:
      return "/api/v2/login/"
    case .nicknameCheck(let nickname):
      return "/api/v2/nickname/\(nickname)"
    }
  }

  var method: Method {
    switch self {
    case .auth:
      return .post
    case .nicknameCheck:
      return .get
    }
  }

  var sampleData: Data { Data() }

  var task: Task {
    switch self {
    case let .auth(type, token):
      let body: [String: Any] = [
        "socialType": type.description,
        "accessToken": token
      ]
      return .requestCompositeParameters(
        bodyParameters: body,
        bodyEncoding: JSONEncoding.default,
        urlParameters: .init()
      )

    case .nicknameCheck:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }
}

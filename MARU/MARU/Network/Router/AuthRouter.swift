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
  case refresh
  case user
  case changeProfile(String)
  case report(chat: RealmChat)
}

extension AuthRouter: TargetType {
  var baseURL: URL {
    return Enviroment.baseURL
  }

  var path: String {
    switch self {
    case .auth(let type, _):
      return "social/login/\(type.description)"
    case .nicknameCheck(let nickname):
      return "nickname/check/\(nickname)"
    case .information:
      return "signup"
    case .refresh:
      return "token/refresh"
    case .user:
      return "user"
    case .changeProfile(let nickname):
      return "user/profile/\(nickname)"
    case .report:
      return "users/report"
    }
  }

  var method: Method {
    switch self {
    case .auth, .information, .refresh, .report:
      return .post
    case .changeProfile:
      return .patch
    default:
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
      body["socialId"] = information.socialID
      body["socialType"] = information.socialType
      body["nickname"] = information.nickname
      return .requestCompositeParameters(
        bodyParameters: body,
        bodyEncoding: JSONEncoding.default,
        urlParameters: .init()
      )
    case .report(let chat):
      let parameters: [String: Any] = [
        "chatId": chat.chatID,
        "reportedUserId": chat.userID
      ]
      return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
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
    case .refresh:
      return [
        "Content-Type": "application/json",
        "RefreshToken": KeychainHandler.shared.refreshToken
      ]
    case .user, .report:
      return [
        "Content-Type": "application/json",
        "accessToken": KeychainHandler.shared.accessToken
      ]
    default:
      return [
        "Content-Type": "application/json"
      ]
    }
  }
}

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
  case signOut
  case changeProfile(nickname: String, image: UIImage)
  case report(chat: RealmChat)
  case userProfile
}

extension AuthRouter: BaseTargetType {
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
    case .signOut:
      return "user"
    case .changeProfile(let nickname, _):
      return "user/profile/\(nickname)"
    case .report:
      return "users/report"
    case .userProfile:
      return "user/profile"
    }
  }

  var method: Method {
    switch self {
    case .auth, .information, .refresh, .report:
      return .post
    case .changeProfile:
      return .patch
    case .signOut:
      return .delete
    default:
      return .get
    }
  }

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
      body["deviceToken"] = KeychainHandler.shared.apnsToken
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
    case let .changeProfile(_, image):
      var multipartData: [MultipartFormData] = []

      if image != UIImage() {
        let imageData = MultipartFormData(
          provider: .data(image.pngData() ?? Data()),
          name: "image",
          fileName: "image.png",
          mimeType: "image/png")
        multipartData.append(imageData)
      } else {
        multipartData.append(.init(provider: .data(Data()),
                                   name: "image",
                                   fileName: "image.png"))
      }
      return .uploadMultipart(multipartData)
    default:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    switch self {
    case let .auth(_, token):
      return [
        "Content-Type": "application/json",
        "accessToken": token,
        "deviceToken": KeychainHandler.shared.apnsToken
      ]
    case .refresh:
      return [
        "Content-Type": "application/json",
        "RefreshToken": KeychainHandler.shared.refreshToken
      ]
    case .user, .report, .userProfile, .signOut:
      return [
        "Content-Type": "application/json",
        "accessToken": KeychainHandler.shared.accessToken
      ]
    case .changeProfile:
      return [
        "Content-Type": "multipart/form-data",
        "accessToken": KeychainHandler.shared.accessToken
      ]
    default:
      return [
        "Content-Type": "application/json"
      ]
    }
  }
}

//
//  Auth.swift
//  MARU
//
//  Created by 오준현 on 2021/06/25.
//

struct Token: Codable {
  let token: Auth
}

struct Auth: Codable {
  let accessToken: String?
  let accessTokenExpiredAt: String?
  let refreshToken: String?
  let refreshTokenExpiredAt: String?
  let socialID: String?

  enum CodingKeys: String, CodingKey {
    case accessToken = "accessToken"
    case accessTokenExpiredAt = "accessTokenExpiredAt"
    case refreshToken = "refreshToken"
    case refreshTokenExpiredAt = "refreshTokenExpiredAt"
    case socialID = "socialId"
  }
}

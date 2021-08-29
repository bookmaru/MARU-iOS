//
//  Auth.swift
//  MARU
//
//  Created by 오준현 on 2021/06/25.
//

struct Token: Codable {
  let token: TokenDTO?
  let socialID: String?

  enum CodingKeys: String, CodingKey {
    case token
    case socialID = "socialId"
  }
}

struct TokenDTO: Codable {
  let tokenResponseDTO: Auth
  let nickname: String?
  let profileURL: String?

  enum CodingKeys: String, CodingKey {
    case tokenResponseDTO = "tokenResponseDto"
    case nickname
    case profileURL = "profileUrl"
  }
}

struct SignupToken: Codable {
  let token: Auth
}

struct Auth: Codable {
  let accessToken: String?
  let accessTokenExpiredAt: String?
  let refreshToken: String?
  let refreshTokenExpiredAt: String?

  enum CodingKeys: String, CodingKey {
    case accessToken
    case accessTokenExpiredAt
    case refreshToken
    case refreshTokenExpiredAt
  }
}

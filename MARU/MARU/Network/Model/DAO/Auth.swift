//
//  Auth.swift
//  MARU
//
//  Created by 오준현 on 2021/06/25.
//

struct LoginDAO: Codable {
  let login: LoginInfoDAO?
  let socialID: SocialID?

  enum CodingKeys: String, CodingKey {
    case login
    case socialID = "socialId"
  }
}

struct SocialID: Codable {
  let userID: Int?
  let socialID: String
  let nickname: String?
  let profileURL: String?
  let userGroupNumbers: Int?
  let tokens: String?

  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case socialID = "socialId"
    case nickname
    case profileURL = "profileUrl"
    case userGroupNumbers
    case tokens
  }
}

struct LoginInfoDAO: Codable {
  let userID: Int
  let nickname: String?
  let profileURL: String?
  let userGroupNumbers: [Int]?
  let tokens: Auth?

  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case nickname
    case profileURL = "profileUrl"
    case userGroupNumbers
    case tokens
  }
}

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
  let userID: Int
  let nickname: String?
  let profileURL: String?

  enum CodingKeys: String, CodingKey {
    case tokenResponseDTO = "tokenResponseDto"
    case userID = "userId"
    case nickname
    case profileURL = "profileUrl"
  }
}

struct SignupToken: Codable {
  let signup: LoginInfoDAO
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

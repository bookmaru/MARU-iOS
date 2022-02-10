//
//  User.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

struct User: Codable {
  let userProfile: UserData?
}

struct UserData: Codable {
  let nickname: String
  let profileURL: String?
  let leaderScore: Double

  enum CodingKeys: String, CodingKey {
    case nickname
    case profileURL = "profileUrl"
    case leaderScore
  }
}

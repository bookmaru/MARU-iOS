//
//  User.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

struct User: Codable {
  let user: UserData?
}

struct UserData: Codable {
  let nickname: String
  let profileImage: String?
  let leaderScore: Int
}

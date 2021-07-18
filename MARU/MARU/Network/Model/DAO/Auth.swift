//
//  Auth.swift
//  MARU
//
//  Created by 오준현 on 2021/06/25.
//

struct Auth: Codable {
  let accessToken: String?
  let socialID: String?

  enum CodingKeys: String, CodingKey {
    case accessToken = "accessToken"
    case socialID = "socialId"
  }
}

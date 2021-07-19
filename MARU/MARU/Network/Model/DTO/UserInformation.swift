//
//  UserInformation.swift
//  MARU
//
//  Created by 오준현 on 2021/07/11.
//

struct UserInformation: Codable {
  var birth: Int?
  var gender: String?
  var nickname: String
  var socialID: String
  var socialType: String
}

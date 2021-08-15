//
//  UserInformation.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/15.
//

struct UserInformation: Codable {
  var birth: Int?
  var gender: String?
  var nickname: String
  var socialID: String
  var socialType: String
}

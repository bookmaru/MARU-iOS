//
//  BaseReponseType.swift
//  MARU
//
//  Created by 오준현 on 2021/06/25.
//

struct BaseReponseType<T: Codable>: Codable {
  let status: Int
  let message: String?
  let data: T?
}

struct BaseArrayResponseType<T: Codable>: Codable {
  let status: Int
  let message: String?
  let data: [T]?
}

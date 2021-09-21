//
//  Enviroment.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

import Foundation

struct Enviroment {
  static let baseURL: URL = URL(string: "http://3.36.251.65:8080/api/v2/")!
  static let socketURL: URL = URL(string: "ws://3.36.251.65:8082/ws/websocket")!
}

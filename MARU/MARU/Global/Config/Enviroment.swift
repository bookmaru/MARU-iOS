//
//  Enviroment.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

import Foundation

struct Enviroment {
  static let baseURL: URL = URL(string: "http://3.36.248.213:8080/api/v2/")!
  static let socketURL: URL = URL(string: "ws://3.36.250.26:8082/ws/websocket")!

  static let devBaseURL: URL = URL(string: "http://3.36.248.213:8081/api/v2/")!
  static let devSocketURL: URL = URL(string: "ws://3.36.250.26:8082/ws/websocket")!
}

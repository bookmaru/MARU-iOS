//
//  Enviroment.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

import Foundation

struct Enviroment {
  // MARU Bundle Setting // BASE_URL 컬럼
//  static var baseURL: String {
//    guard let url = Bundle.main.infoDictionary?["BaseURL"] as? String else { return "" }
//    return url
//  }
  static let baseURL: URL = URL(string: "http://3.36.251.65:8080/api/v2/")!
  static let socketURL: URL = URL(string: "ws://3.36.251.65:8081/ws/websocket")!
}

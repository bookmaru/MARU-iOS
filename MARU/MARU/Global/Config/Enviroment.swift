//
//  Enviroment.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

import Foundation

struct Enviroment {
  // MARU Bundle Setting // BASE_URL 컬럼
  static var baseURL: String {
    guard let url = Bundle.main.infoDictionary?["BaseURL"] as? String else { return "" }
    return url
  }
}

//
//  Enviroment.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

import Foundation

struct Enviroment {
  // MARU Bundle Setting // BASE_URL 컬럼
  static let baseURL = Bundle.main.infoDictionary?["BaseURL"] as? String
}

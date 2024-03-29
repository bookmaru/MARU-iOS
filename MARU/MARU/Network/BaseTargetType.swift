//
//  BaseTargetType.swift
//  MARU
//
//  Created by 오준현 on 2021/10/29.
//

import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {
  var baseURL: URL {
    #if DEBUG
    return Enviroment.devBaseURL
    #else
    return Enviroment.baseURL
    #endif
  }

  var sampleData: Data {
    return Data()
  }

  var headers: [String: String]? {
    return [
      "Content-Type": "application/json",
      "Authorization": KeychainHandler.shared.accessToken
    ]
  }
}

//
//  Library.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/01.
//

import Foundation

enum Library {
  case title(title: String, isHidden: Bool)
  case meeting([String])
  case diary([String])
  
  var count: Int {
    switch self {
    case .title: return 1
    case .meeting(let data): return data.count
    case .diary(let data): return data.count
    }
  }
}

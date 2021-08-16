//
//  Library.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/01.
//

import UIKit

enum Library {
  case title(title: String, isHidden: Bool)
  case meeting([String])
  case diary(diary: Diaries)
  
  var count: Int {
    switch self {
    case .title:
      return 1
    case .meeting(let data):
      return data.count
    case .diary(let data):
      return data.diaries.count
    }
  }
  
  var size: CGSize {
    switch self {
    case .title:
      return CGSize(width: ScreenSize.width, height: 60)
    case .meeting:
      return CGSize(width: ScreenSize.width, height: 134)
    case .diary:
      return CGSize(width: ScreenSize.width - 40, height: 204)
    }
  }
}

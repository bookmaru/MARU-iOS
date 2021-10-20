//
//  Library.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/01.
//

import UIKit

enum Library {
  case title(title: String, isHidden: Bool)
  case meeting(meeting: KeepGroupModel)
  case book(book: BookCaseModel)
  case diary(diary: Diaries)
  var count: Int {
    switch self {
    case .title:
      return 1
    case .meeting(let data):
      if data.keepGroup.count == 0 {
        return 1
      } else {
        return data.keepGroup.count
      }
      // 데이터 값 안 들어올 경우 return 1로 처리해서 데이터가 없는 상태를 업데이트 해주자
      // 현재 유저는 서재 관련한 아무 데이터를 받아오고 오지 않아서 0개임.(빈 배열) 따라서 collectionview에서 카운트가 안되니 아무것도 안보이는것.
    case .book(let data):
      if data.bookcase.count == 0 {
        return 1
      } else {
        return data.bookcase.count
      }
    case .diary(let data):
      return data.diaries.count
    }
  }
  var size: CGSize {
    switch self {
    case .title:
      return CGSize(width: ScreenSize.width, height: 60)
    case .meeting(let data):
      if data.keepGroup.count > 0 {
        return CGSize(width: ScreenSize.width / 4, height: 134)
      }
      return CGSize(width: ScreenSize.width, height: 134)
    case .book:
      return CGSize(width: ScreenSize.width, height: 134)
    case .diary:
      return CGSize(width: ScreenSize.width - 40, height: 204)
    }
  }
}

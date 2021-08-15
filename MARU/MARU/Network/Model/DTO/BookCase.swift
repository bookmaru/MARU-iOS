//
//  BookCase.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/15.
//

import Foundation
// v2/bookcase 전용
struct Case: Codable {
  let bookcaseId: Int
  let isbn: String
  let title: String
  let author: String
  let imageUrl: String
}
struct BookCase: Codable {
  let bookcase: [Case]
}

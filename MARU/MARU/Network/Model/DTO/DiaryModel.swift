//
//  DiaryModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/16.
//

struct Diary: Codable {
  let diaries:[Diaries]
}

struct Diaries: Codable {
  let diaryId: Int
  let diaryTitle: String
  let createdAt: String
  let bookTitle: String
  let bookAuthor: String
  let bookImage: String
}

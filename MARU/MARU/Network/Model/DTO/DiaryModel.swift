//
//  DiaryModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/16.
//

struct Diaries: Codable {
  let diaries: [Diary]
}

struct Diary: Codable {
  let diaryID: Int
  let diaryTitle: String
  let createdAt: String
  let bookTitle: String
  let bookAuthor: String
  let bookImage: String
}
// MARK: - 일기 1개에 대한 자세한 정보 get
struct DiaryInfo: Codable {
  let diaryID: Int
  let diaryTitle: String
  let content: String
  let createdAt: String
  let bookTitle: String
  let bookAuthor: String
  let bookImage: String
  let nickName: String
  let profileImage: String
}

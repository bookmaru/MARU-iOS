//
//  MeetEntryModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/05/03.
//
//  모임 입장 화면 모델

import Foundation

struct MeetEntryModel: Codable {
  let bookTitle: String
  let bookAuthor: String
  let meetDate: String // 방 유효 일수
  let meetOwner: String // 방장
  let ownerScore: String // 방장 평점
  let meetParticipant: String // 방장 참여
  let meetIntro: String // 방 소개 한줄
}

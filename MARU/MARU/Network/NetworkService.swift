//
//  NetworkService.swift
//  MARU
//
//  Created by 오준현 on 2021/05/09.
//

final class NetworkService {
  static let shared = NetworkService()

  private init() {}

  let auth = AuthService()
  let home = HomeService()
  let groupSearch = SearchService()
  let diary = DiaryService()
  let book = BookService()
  let quiz = QuizService()
}

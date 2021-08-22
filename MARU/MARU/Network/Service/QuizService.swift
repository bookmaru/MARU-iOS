//
//  QuizService.swift
//  MARU
//
//  Created by psychehose on 2021/08/21.
//

import Moya
import RxSwift

protocol QuizServiceType {
  func getQuiz(groupID: Int) -> Observable<BaseReponseType<Quizs>>
  func checkQuiz(groupID: Int, isEnter: String) -> Observable<BaseReponseType<CheckQuiz>>
}

final class QuizService: QuizServiceType {
  private let router = MoyaProvider<QuizRouter>(plugins: [NetworkLoggerPlugin()])

  func getQuiz(groupID: Int) -> Observable<BaseReponseType<Quizs>> {
    return router.rx
      .request(.getQuiz(groupID: groupID))
      .asObservable()
      .map(BaseReponseType<Quizs>.self)
  }
  func checkQuiz(groupID: Int, isEnter: String) -> Observable<BaseReponseType<CheckQuiz>> {
    return router.rx
      .request(.checkQuiz(groupID: groupID, isEnter: isEnter))
      .asObservable()
      .map(BaseReponseType<CheckQuiz>.self)
  }
}

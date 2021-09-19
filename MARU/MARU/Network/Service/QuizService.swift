//
//  QuizService.swift
//  MARU
//
//  Created by psychehose on 2021/08/21.
//

import Moya
import RxSwift

protocol QuizServiceType {
  func createQuiz(makeGroup: MakeGroup) -> Observable<BaseReponseType<ResultMakeGroup>>
  func getQuiz(groupID: Int) -> Observable<BaseReponseType<Quizzes>>
  func checkQuiz(groupID: Int, isEnter: String) -> Observable<BaseReponseType<CheckQuiz>>
}

final class QuizService: QuizServiceType {
  private let router = MoyaProvider<QuizRouter>(plugins: [NetworkLoggerPlugin(verbose: false)])
  func createQuiz(makeGroup: MakeGroup) -> Observable<BaseReponseType<ResultMakeGroup>> {
    return router.rx
      .request(.createQuiz(makeGroup: makeGroup))
      .asObservable()
      .map(BaseReponseType<ResultMakeGroup>.self)
  }
  func getQuiz(groupID: Int) -> Observable<BaseReponseType<Quizzes>> {
    return router.rx
      .request(.getQuiz(groupID: groupID))
      .asObservable()
      .map(BaseReponseType<Quizzes>.self)
  }
  func checkQuiz(groupID: Int, isEnter: String) -> Observable<BaseReponseType<CheckQuiz>> {
    return router.rx
      .request(.checkQuiz(groupID: groupID, isEnter: isEnter))
      .asObservable()
      .map(BaseReponseType<CheckQuiz>.self)
  }
}

//
//  QuizService.swift
//  MARU
//
//  Created by psychehose on 2021/08/21.
//

import Moya
import RxSwift

protocol QuizServiceType {
  func createQuiz(makeGroup: MakeGroup) -> Observable<BaseResponseType<ResultMakeGroup>>
  func getQuiz(groupID: Int) -> Observable<BaseResponseType<Quizzes>>
  func checkQuiz(groupID: Int, isEnter: String) -> Observable<BaseResponseType<CheckQuiz>>
}

final class QuizService: QuizServiceType {
  private let router = MoyaProvider<QuizRouter>(plugins: [NetworkLoggerPlugin(verbose: false)])
  func createQuiz(makeGroup: MakeGroup) -> Observable<BaseResponseType<ResultMakeGroup>> {
    return router.rx
      .request(.createQuiz(makeGroup: makeGroup))
      .asObservable()
      .map(BaseResponseType<ResultMakeGroup>.self)
      .catchError()
  }
  func getQuiz(groupID: Int) -> Observable<BaseResponseType<Quizzes>> {
    return router.rx
      .request(.getQuiz(groupID: groupID))
      .asObservable()
      .map(BaseResponseType<Quizzes>.self)
      .catchError()
  }
  func checkQuiz(groupID: Int, isEnter: String) -> Observable<BaseResponseType<CheckQuiz>> {
    return router.rx
      .request(.checkQuiz(groupID: groupID, isEnter: isEnter))
      .asObservable()
      .map(BaseResponseType<CheckQuiz>.self)
      .catchError()
  }
}

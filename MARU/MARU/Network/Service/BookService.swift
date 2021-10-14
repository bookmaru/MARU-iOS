//
//  BookService.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import Moya
import RxSwift

protocol BookServiceType {
  func bookList() -> Observable<BaseReponseType<BookCaseModel>>
  func getGroup() -> Observable<BaseReponseType<KeepGroupModel>>
  func addGroup(groupID: Int) -> Observable<BaseReponseType<Int>>
}

final class BookService: BookServiceType {
  private let router = MoyaProvider<BookRouter>(plugins: [NetworkLoggerPlugin(verbose: true)])

  func bookList() -> Observable<BaseReponseType<BookCaseModel>> {
    return router.rx
      .request(.get)
      .asObservable()
      .map(BaseReponseType<BookCaseModel>.self)
  }
  func getGroup() -> Observable<BaseReponseType<KeepGroupModel>> {
    return router.rx
      .request(.group)
      .asObservable()
      .map(BaseReponseType<KeepGroupModel>.self)
  }
  func addGroup(groupID: Int) -> Observable<BaseReponseType<Int>> {
    return router.rx
      .request(.addGroup(groupID: groupID))
      .asObservable()
      .map(BaseReponseType<Int>.self)
  }
}

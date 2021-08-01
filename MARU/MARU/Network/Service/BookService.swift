//
//  BookService.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import Moya
import RxSwift

protocol BookServiceType {
  func bookList() -> Observable<BaseReponseType<[String]>>
  func getGroup() -> Observable<BaseReponseType<[String]>>
}

final class BookService: BookServiceType {
  private let router = MoyaProvider<BookRouter>(plugins: [NetworkLoggerPlugin()])

  func bookList() -> Observable<BaseReponseType<[String]>> {
    return router.rx
      .request(.get)
      .asObservable()
      .map(BaseReponseType<[String]>.self)
  }
  func getGroup() -> Observable<BaseReponseType<[String]>> {
    return router.rx
      .request(.group)
      .asObservable()
      .map(BaseReponseType<[String]>.self)
  }
}

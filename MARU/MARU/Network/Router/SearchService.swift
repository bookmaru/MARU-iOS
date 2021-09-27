//
//  SearchService.swift
//  MARU
//
//  Created by psychehose on 2021/07/28.
//

import Moya
import RxSwift

protocol SearchServiceType {
  func search(queryString: String) -> Observable<BaseReponseType<Groups>>
  func bookSearch(queryString: String, page: Int) -> Observable<BaseReponseType<Books>>
  func meetingSearchByISBN(isbn: Int, page: Int) -> Observable<BaseReponseType<Groups>>
}

final class SearchService: SearchServiceType {

  private let router = MoyaProvider<SearchRouter>(plugins: [NetworkLoggerPlugin(verbose: false)])

  func search(queryString: String) -> Observable<BaseReponseType<Groups>> {
    return router.rx
      .request(.search(queryString: queryString))
      .asObservable()
      .map(BaseReponseType<Groups>.self)
  }

  func bookSearch(queryString: String, page: Int) -> Observable<BaseReponseType<Books>> {
    return router.rx
      .request(.bookSearch(queryString: queryString, page: page))
      .asObservable()
      .map(BaseReponseType<Books>.self)
  }

  func meetingSearchByISBN(isbn: Int, page: Int) -> Observable<BaseReponseType<Groups>> {
    return router.rx
      .request(.meetingSearchByISBN(isbn: isbn.string, page: page))
      .asObservable()
      .map(BaseReponseType<Groups>.self)
  }
}

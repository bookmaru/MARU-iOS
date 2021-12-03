//
//  SearchService.swift
//  MARU
//
//  Created by psychehose on 2021/07/28.
//

import Moya
import RxSwift

protocol SearchServiceType {
  func search(queryString: String) -> Observable<BaseResponseType<Groups>>
  func bookSearch(queryString: String, page: Int) -> Observable<BaseResponseType<Books>>
  func meetingSearchByISBN(isbn: Int, page: Int) -> Observable<BaseResponseType<Groups>>
}

final class SearchService: SearchServiceType {

  private let router = MoyaProvider<SearchRouter>(plugins: [NetworkLoggerPlugin(verbose: false)])

  func search(queryString: String) -> Observable<BaseResponseType<Groups>> {
    return router.rx
      .request(.search(queryString: queryString))
      .asObservable()
      .map(BaseResponseType<Groups>.self)
      .catchError()
  }

  func bookSearch(queryString: String, page: Int) -> Observable<BaseResponseType<Books>> {
    return router.rx
      .request(.bookSearch(queryString: queryString, page: page))
      .asObservable()
      .map(BaseResponseType<Books>.self)
      .catchError()
  }

  func meetingSearchByISBN(isbn: Int, page: Int) -> Observable<BaseResponseType<Groups>> {
    return router.rx
      .request(.meetingSearchByISBN(isbn: isbn.string, page: page))
      .asObservable()
      .map(BaseResponseType<Groups>.self)
      .catchError()
  }
}

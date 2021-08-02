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
}

final class SearchService: SearchServiceType {
  private let router = MoyaProvider<SearchRouter>(plugins: [NetworkLoggerPlugin(verbose: true)])
  
  func search(queryString: String) -> Observable<BaseReponseType<Groups>> {
    return router.rx
      .request(.search(queryString: queryString))
      .asObservable()
      .map(BaseReponseType<Groups>.self)
  }

//  func getPopular() -> Observable<BaseReponseType<Books>> {
//    return router.rx
//      .request(.getPopular)
//      .asObservable()
//      .map(BaseReponseType<Books>.self)
//  }
}

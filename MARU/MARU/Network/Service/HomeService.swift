//
//  HomeService.swift
//  MARU
//
//  Created by psychehose on 2021/07/09.
//

import Moya
import RxSwift

protocol HomeServiceType {
  func getPopular() -> Observable<BaseReponseType<Books>>
}

final class HomeService: HomeServiceType {
  private let router = MoyaProvider<HomeRouter>(plugins: [NetworkLoggerPlugin(verbose: true)])

  func getPopular() -> Observable<BaseReponseType<Books>> {
    return router.rx
      .request(.getPopular)
      .asObservable()
      .map(BaseReponseType<Books>.self)
  }
}

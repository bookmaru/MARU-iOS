//
//  DiaryService.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import Moya
import RxSwift

protocol DiaryServiceType {
  func getDiaryList() -> Observable<BaseReponseType<[String]>>
  func getDiary() -> Observable<BaseReponseType<String>>
}

final class DiaryService: DiaryServiceType {
  private let router = MoyaProvider<DiaryRouter>(plugins: [NetworkLoggerPlugin()])

  func getDiaryList() -> Observable<BaseReponseType<[String]>> {
    router.rx
      .request(.list)
      .asObservable()
      .map(BaseReponseType<[String]>.self)
  }

  func getDiary() -> Observable<BaseReponseType<String>> {
    return router.rx
      .request(.get)
      .asObservable()
      .map(BaseReponseType<String>.self)
  }
}

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
  func getNew() -> Observable<BaseReponseType<Groups>>
  func getNewAllCategory() -> Observable<BaseReponseType<GroupsByCategories>>
  func getNewCategory(category: String, currentGroupCount: Int)-> Observable<BaseReponseType<Groups>>
}

final class HomeService: HomeServiceType {
  private let router = MoyaProvider<HomeRouter>(plugins: [NetworkLoggerPlugin(verbose: false)])
  func getPopular() -> Observable<BaseReponseType<Books>> {
    return router.rx
      .request(.getPopular)
      .asObservable()
      .map(BaseReponseType<Books>.self)
  }
  func getNew() -> Observable<BaseReponseType<Groups>> {
    return router.rx
      .request(.getNew)
      .asObservable()
      .map(BaseReponseType<Groups>.self)
  }
  func getNewAllCategory() -> Observable<BaseReponseType<GroupsByCategories>> {
    return router.rx
      .request(.getNewAllCategory)
      .asObservable()
      .map(BaseReponseType<GroupsByCategories>.self)
  }
  func getNewCategory(category: String, currentGroupCount: Int) -> Observable<BaseReponseType<Groups>> {
    return router.rx
      .request(.getNewCategory(category: category, currentGroupCount: currentGroupCount))
      .asObservable()
      .map(BaseReponseType<Groups>.self)
  }
}

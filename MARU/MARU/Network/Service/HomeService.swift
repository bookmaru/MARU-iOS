//
//  HomeService.swift
//  MARU
//
//  Created by psychehose on 2021/07/09.
//

import Moya
import RxSwift

protocol HomeServiceType {
  func getPopular() -> Observable<BaseResponseType<Books>>
  func getNew(page: Int) -> Observable<BaseResponseType<Groups>>
  func getNewAllCategory() -> Observable<BaseResponseType<GroupsByCategories>>
  func getNewCategory(category: String, currentGroupCount: Int)-> Observable<BaseResponseType<Groups>>
}

final class HomeService: HomeServiceType {
  private let router = MoyaProvider<HomeRouter>(plugins: [NetworkLoggerPlugin(verbose: false)])
  func getPopular() -> Observable<BaseResponseType<Books>> {
    return router.rx
      .request(.getPopular)
      .asObservable()
      .map(BaseResponseType<Books>.self)
      .catchError()
  }
  func getNew(page: Int) -> Observable<BaseResponseType<Groups>> {
    return router.rx
      .request(.getNew(page: page))
      .asObservable()
      .map(BaseResponseType<Groups>.self)
      .catchError()
  }
  func getNewAllCategory() -> Observable<BaseResponseType<GroupsByCategories>> {
    return router.rx
      .request(.getNewAllCategory)
      .asObservable()
      .map(BaseResponseType<GroupsByCategories>.self)
      .catchError()
  }
  func getNewCategory(category: String, currentGroupCount: Int) -> Observable<BaseResponseType<Groups>> {
    return router.rx
      .request(.getNewCategory(category: category, currentGroupCount: currentGroupCount))
      .asObservable()
      .map(BaseResponseType<Groups>.self)
      .catchError()
  }
}

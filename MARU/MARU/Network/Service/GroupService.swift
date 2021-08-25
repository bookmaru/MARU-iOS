//
//  GroupService.swift
//  MARU
//
//  Created by 오준현 on 2021/08/24.
//

import Moya
import RxSwift

protocol GroupServiceType {
  func participateList() -> Observable<BaseReponseType<Groups>>
}

final class GroupService: GroupServiceType {
  private let router = MoyaProvider<GroupRouter>(plugins: [NetworkLoggerPlugin()])

  func participateList() -> Observable<BaseReponseType<Groups>> {
    return router.rx
      .request(.participate)
      .asObservable()
      .map(BaseReponseType<Groups>.self)
  }
}
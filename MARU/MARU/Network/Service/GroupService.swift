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
  func chatList(roomID: Int) -> Observable<[RealmChat]>
}

final class GroupService: GroupServiceType {
  private let router = MoyaProvider<GroupRouter>(plugins: [NetworkLoggerPlugin(verbose: true)])

  func participateList() -> Observable<BaseReponseType<Groups>> {
    return router.rx
      .request(.participate)
      .asObservable()
      .map(BaseReponseType<Groups>.self)
  }

  func chatList(roomID: Int) -> Observable<[RealmChat]> {
    return router.rx
      .request(.chatList(roomID: roomID))
      .asObservable()
      .map([RealmChat].self)
  }
}

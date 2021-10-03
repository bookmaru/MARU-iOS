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
  func diaryList() -> Observable<BaseReponseType<Groups>>
  func groupInfo(groupID: Int) -> Observable<BaseReponseType<GroupInformation>>
}

final class GroupService: GroupServiceType {

  private let router = MoyaProvider<GroupRouter>(plugins: [NetworkLoggerPlugin(verbose: false)])

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

  func diaryList() -> Observable<BaseReponseType<Groups>> {
    return router.rx
      .request(.diaryList)
      .asObservable()
      .map(BaseReponseType<Groups>.self)
  }

  func groupInfo(groupID: Int) -> Observable<BaseReponseType<GroupInformation>> {
    return router.rx
      .request(.groupInfo(groupID: groupID))
      .asObservable()
      .map(BaseReponseType<GroupInformation>.self)
  }
}

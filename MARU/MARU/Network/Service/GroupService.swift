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
  func keep(groupID: Int) -> Observable<BaseReponseType<HasGroup>>
  func postEvaluate(groupID: Int, leaderID: Int, score: Int) -> Observable<BaseReponseType<Int>>
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

  func keep(groupID: Int) -> Observable<BaseReponseType<HasGroup>> {
    return router.rx
      .request(.keep(groupID: groupID))
      .asObservable()
      .map(BaseReponseType<HasGroup>.self)
  }

  // /api/v2/group/1/leader/1?score=4.5
  func postEvaluate(groupID: Int, leaderID: Int, score: Int) -> Observable<BaseReponseType<Int>> {
    return router.rx
      .request(.evaluate(groupID: groupID, leaderID: leaderID, score: score))
      .asObservable()
      .map(BaseReponseType<Int>.self)
  }
}

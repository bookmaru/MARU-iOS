//
//  GroupService.swift
//  MARU
//
//  Created by 오준현 on 2021/08/24.
//

import Moya
import RxSwift

protocol GroupServiceType {
  func participateList() -> Observable<BaseResponseType<Groups>>
  func chatList(roomID: Int) -> Observable<[RealmChat]>
  func diaryList() -> Observable<BaseResponseType<Groups>>
  func groupInfo(groupID: Int) -> Observable<BaseResponseType<GroupInformation>>
  func keep(groupID: Int) -> Observable<BaseResponseType<HasGroup>>
  func postEvaluate(groupID: Int, leaderID: Int, score: Int) -> Observable<BaseResponseType<Int>>
}

final class GroupService: GroupServiceType {

  private let router = MoyaProvider<GroupRouter>(plugins: [NetworkLoggerPlugin(verbose: true)])

  func participateList() -> Observable<BaseResponseType<Groups>> {
    return router.rx
      .request(.participate)
      .asObservable()
      .map(BaseResponseType<Groups>.self)
      .catchError()
  }

  func chatList(roomID: Int) -> Observable<[RealmChat]> {
    return router.rx
      .request(.chatList(roomID: roomID))
      .asObservable()
      .map([RealmChat].self)
      .catchError()
  }

  func diaryList() -> Observable<BaseResponseType<Groups>> {
    return router.rx
      .request(.diaryList)
      .asObservable()
      .map(BaseResponseType<Groups>.self)
      .catchError()
  }

  func groupInfo(groupID: Int) -> Observable<BaseResponseType<GroupInformation>> {
    return router.rx
      .request(.groupInfo(groupID: groupID))
      .asObservable()
      .map(BaseResponseType<GroupInformation>.self)
      .catchError()
  }

  func keep(groupID: Int) -> Observable<BaseResponseType<HasGroup>> {
    return router.rx
      .request(.keep(groupID: groupID))
      .asObservable()
      .map(BaseResponseType<HasGroup>.self)
      .catchError()
  }

  func postEvaluate(groupID: Int, leaderID: Int, score: Int) -> Observable<BaseResponseType<Int>> {
    return router.rx
      .request(.evaluate(groupID: groupID, leaderID: leaderID, score: score))
      .asObservable()
      .map(BaseResponseType<Int>.self)
      .catchError()
  }
}

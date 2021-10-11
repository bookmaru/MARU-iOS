//
//  DiaryService.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import Moya
import RxSwift

protocol DiaryServiceType {
  func getDiaryList() -> Observable<BaseReponseType<Diaries>>
  func getDiary(diaryID: Int) -> Observable<BaseReponseType<DiaryInfo>>
  func postDiary(groupID: Int, title: String, content: String) -> Observable<BaseReponseType<Int>>
}

final class DiaryService: DiaryServiceType {
  private let router = MoyaProvider<DiaryRouter>(plugins: [NetworkLoggerPlugin(verbose: false)])

  func getDiaryList() -> Observable<BaseReponseType<Diaries>> {
    router.rx
      .request(.list)
      .asObservable()
      .map(BaseReponseType<Diaries>.self)
  }

  func getDiary(diaryID: Int) -> Observable<BaseReponseType<DiaryInfo>> {
    return router.rx
      .request(.get(diaryID: diaryID))
      .asObservable()
      .map(BaseReponseType<DiaryInfo>.self)
  }

  func postDiary(groupID: Int, title: String, content: String) -> Observable<BaseReponseType<Int>> {
    return router.rx
      .request(.post(groupID: groupID, title: title, content: content))
      .asObservable()
      .map(BaseReponseType<Int>.self)
  }

}

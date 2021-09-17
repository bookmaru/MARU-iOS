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
  func getDiary(diaryId: Int) -> Observable<BaseReponseType<DiaryInfo>>
}

final class DiaryService: DiaryServiceType {
  private let router = MoyaProvider<DiaryRouter>(plugins: [NetworkLoggerPlugin(verbose: false)])

  func getDiaryList() -> Observable<BaseReponseType<Diaries>> {
    router.rx
      .request(.list)
      .asObservable()
      .map(BaseReponseType<Diaries>.self)
  }

  func getDiary(diaryId: Int) -> Observable<BaseReponseType<DiaryInfo>> {
    return router.rx
      .request(.get(diaryId: diaryId))
      .asObservable()
      .map(BaseReponseType<DiaryInfo>.self)
  }
}

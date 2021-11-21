//
//  DiaryService.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import Moya
import RxSwift

protocol DiaryServiceType {
  func getDiaryList() -> Observable<BaseResponseType<Diaries>>
  func getDiary(diaryID: Int) -> Observable<BaseResponseType<DiaryObject>>
  func postDiary(groupID: Int, title: String, content: String) -> Observable<BaseResponseType<Int>>
  func editDiary(groupID: Int, title: String, content: String) -> Observable<BaseResponseType<Int>>
}

final class DiaryService: DiaryServiceType {
  private let router = MoyaProvider<DiaryRouter>(plugins: [NetworkLoggerPlugin(verbose: false)])

  func getDiaryList() -> Observable<BaseResponseType<Diaries>> {
    return router.rx
      .request(.list)
      .asObservable()
      .map(BaseResponseType<Diaries>.self)
  }

  func getDiary(diaryID: Int) -> Observable<BaseResponseType<DiaryObject>> {
    return router.rx
      .request(.get(diaryID: diaryID))
      .asObservable()
      .map(BaseResponseType<DiaryObject>.self)
  }

  func postDiary(groupID: Int, title: String, content: String) -> Observable<BaseResponseType<Int>> {
    return router.rx
      .request(.post(groupID: groupID, title: title, content: content))
      .asObservable()
      .map(BaseResponseType<Int>.self)
  }

  func editDiary(groupID: Int, title: String, content: String) -> Observable<BaseResponseType<Int>> {
    return router.rx.request(.edit(diaryID: groupID, title: title, content: content))
      .asObservable()
      .map(BaseResponseType<Int>.self)
  }

}

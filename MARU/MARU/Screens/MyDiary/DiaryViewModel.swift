//
//  DiaryViewModel.swift
//  MARU
//
//  Created by 오준현 on 2021/10/11.
//

import RxSwift

final class DiaryViewModel {

  struct Input {
    let viewDidLoad: Observable<Void>
  }

  struct Output {
    let info: Observable<DiaryInfo>
    let group: Observable<Group>
  }

  private let diaryID: Int

  init(diaryID: Int) {
    self.diaryID = diaryID
  }

  func transform(input: Input) -> Output {
    let response = input.viewDidLoad
      .flatMap { NetworkService.shared.diary.getDiary(diaryID: self.diaryID) }
      .share()

    let info = response
      .compactMap { $0.data?.diary }

    let group = response
      .compactMap { $0.data?.group }

    return Output(info: info, group: group)
  }
}

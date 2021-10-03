//
//  MyDiaryViewModel.swift
//  MARU
//
//  Created by 오준현 on 2021/09/19.
//

import RxCocoa
import RxSwift

final class MyDiaryViewModel {

  struct Input {
    let viewDidLoad: Observable<Void>
  }

  struct Output {
    let groupList: Driver<[Group]>
  }

  func transform(input: Input) -> Output {
    let groupList = input.viewDidLoad
        .flatMap { NetworkService.shared.group.diaryList() }
        .compactMap { $0.data?.groups }
        .asDriver(onErrorJustReturn: [])

    return Output(groupList: groupList)
  }
}

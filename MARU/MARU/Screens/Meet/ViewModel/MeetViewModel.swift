//
//  MeetViewModel.swift
//  MARU
//
//  Created by 오준현 on 2021/04/05.
//

import RxCocoa
import RxSwift

final class MeetViewModel {

  struct Input {
    let viewDidLoadPublisher: PublishSubject<Void>
  }

  struct Output {
    let group: Driver<[MeetCase]>
  }

  func transform(input: Input) -> Output {
    let output = input.viewDidLoadPublisher
      .flatMap { NetworkService.shared.group.participateList() }
      .map { $0.data.map { $0.groups } }
      .compactMap { $0 }
      .map { groups -> [MeetCase] in
        if groups.isEmpty {
          return [.empty]
        }
        let meet = groups.map { MeetCase.meet($0) }
        if meet.count < 3 {
          return meet + [.empty]
        }
        return meet
      }
      .asDriver(onErrorJustReturn: [])

    return Output(group: output)
  }
}

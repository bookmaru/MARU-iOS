//
//  JoinViewModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/10/04.
//

import RxCocoa
import RxSwift

final class JoinViewModel {
  struct Input {
    let viewDidLoadPublisher: PublishSubject<Void>
    let groupID: Int
  }
  struct Output {
    let data: Driver<GroupInformation?>
  }
  func transform(input: Input) -> Output {
    let viewDidLoad = input.viewDidLoadPublisher.share()
    let groupID = input.groupID
    let groupInfo = viewDidLoad
      .flatMap { NetworkService.shared.group.groupInfo(groupID: groupID) }
      .map { response -> GroupInformation? in
        return response.data
      }
      .asDriver(onErrorJustReturn: nil)
    return Output(data: groupInfo)
  }
}

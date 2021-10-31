//
//  PastMeetingViewModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/29.
//

import RxCocoa
import RxSwift

final class PastMeetingViewModel {
  struct Input {
    let viewDidLoadPublisher: PublishSubject<Void>
  }
  struct Output {
    let data: Driver<KeepGroupModel?>
  }
  func transfrom(input: Input) -> Output {
    let meetingList = input.viewDidLoadPublisher
      .flatMap(NetworkService.shared.book.getGroup)
      .compactMap { $0.data }
      .asDriver(onErrorJustReturn: nil) // nil로 반환해주니까 옵셔널처리 Ouput에서

    return Output(data: meetingList)
  }
}

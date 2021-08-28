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
    let viewDidLoad = input.viewDidLoadPublisher.share()
    let meetingList = viewDidLoad
      .flatMap { NetworkService.shared.book.getGroup() }
      .map { response -> KeepGroupModel? in
        return response.data
      }
      .asDriver(onErrorJustReturn: nil) // nil로 반환해주니까 옵셔널처리 Ouput에서 해줘야
    
    return Output(data: meetingList)
  }
}

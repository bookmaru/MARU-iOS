//
//  NicknameCheckViewModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/11/09.
//

import RxCocoa
import RxSwift

final class NicknameCheckViewModel {
  struct Input {
    let changeNickname: PublishSubject<Void>
    let nickname: String
  }

  struct Output {
    let isSuccess: Observable<Int>
  }

  func transform(input: Input) -> Output {
    let nickname = input.nickname
    let isSuccess = input.changeNickname.share()
      .flatMap {
        NetworkService.shared.auth.nickname(name: nickname)}
      .map { return $0.status}
    return Output(isSuccess: isSuccess)
  }
}

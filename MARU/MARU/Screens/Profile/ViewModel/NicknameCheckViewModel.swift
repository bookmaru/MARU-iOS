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
    let ChangeNickname: PublishSubject<Void>
    let nickname: String
  }

  struct Output {
    let isSuccess: Observable<Bool>
  }

  func transform(input: Input) -> Output {
    let nickname = input.nickname
    let isSuccess = input.ChangeNickname.share()
      .flatMap {
        NetworkService.shared.auth.nickname(name: nickname)}
      .map { $0.status == 200 }
    return Output(isSuccess: isSuccess)
  }
}

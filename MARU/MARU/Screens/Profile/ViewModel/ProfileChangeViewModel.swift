//
//  ProfileChangeViewModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/08.
//

import RxCocoa
import RxSwift

final class ProfileChangeViewModel {
  struct Input {
    let didTapSubmitButton: Observable<(nickname: String, image: UIImage)>
  }

  struct Output {
    let isConnected: Observable<Bool>
  }

  func transform(input: Input) -> Output {
    let isConnected = input.didTapSubmitButton
      .flatMap { NetworkService.shared.auth.change(nickname: $0, image: $1) }
      .map { $0.status == 200 }
    return Output(isConnected: isConnected)
  }
}

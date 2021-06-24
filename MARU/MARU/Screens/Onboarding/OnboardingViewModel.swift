//
//  OnboardingViewModel.swift
//  MARU
//
//  Created by 오준현 on 2021/06/22.
//

import RxCocoa
import RxSwift

final class OnboardingViewModel: ViewModelType {
  struct Input {
    let viewDidLoad: PublishSubject<Void>
    let didTapLoginButton: PublishSubject<(AuthType, String)>
  }

  struct Output {
    let isInitialUser: Driver<Bool>
    let didLogin: Driver<Bool>
  }

  func transform(input: Input) -> Output {
    let isInitialUser = input.viewDidLoad
      .map { _ -> Bool in
        if UserDefaultHandler.shared.isInitalUserKey {
          return true
        }
        UserDefaultHandler.shared.isInitalUserKey = true
        return false
      }
      .asDriver(onErrorJustReturn: false)

    let didLogin = input.didTapLoginButton
      .map { _, token -> Bool in
        if token != "" {
          KeychainHandler.shared.accessToken = token
          return true
        }
        return false
      }.asDriver(onErrorJustReturn: false)

    return Output(isInitialUser: isInitialUser, didLogin: didLogin)
  }

}

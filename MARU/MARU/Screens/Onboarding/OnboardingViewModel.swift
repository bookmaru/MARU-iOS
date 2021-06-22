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
    let didTapAppleLogin: PublishSubject<Void>
    let didTapKakaoLoginButton: PublishSubject<Void>
  }

  struct Output {
    let isInitialUser: Driver<Bool>
    let didLogin: Driver<String>
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

    let appleLogin = input.didTapAppleLogin
      .map { "apple" }
      .asDriver(onErrorJustReturn: "")

    let kakaoLogin = input.didTapKakaoLoginButton
      .map { "kakao" }
      .asDriver(onErrorJustReturn: "")

    let didLogin = Driver.combineLatest(appleLogin, kakaoLogin)
      .map { apple, kakao -> String in
        if apple != "" {
          return apple
        }
        return kakao
      }

    return Output(isInitialUser: isInitialUser, didLogin: didLogin)
  }
}

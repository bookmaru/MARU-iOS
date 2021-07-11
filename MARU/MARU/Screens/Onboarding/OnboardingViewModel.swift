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
    let didTapLoginButton: PublishSubject<(String, Int)>
  }

  struct Output {
    let isInitialUser: Driver<Bool>
    let didLogin: Driver<UIViewController?>
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
      .map { token, statusCode -> UIViewController? in
        if token != "" {
          KeychainHandler.shared.accessToken = token
        }
        if statusCode == 200 {
          return CertificationViewController()
        }
        if statusCode == 201 {
          return TabBarController()
        }
        return nil
      }
      .asDriver(onErrorJustReturn: nil)

    return Output(isInitialUser: isInitialUser, didLogin: didLogin)
  }

}

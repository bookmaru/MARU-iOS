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
      .flatMap { NetworkService.shared.auth.auth(type: $0.0, token: $0.1) }
      .map { response -> UIViewController? in
        if let token = response.data?.accessToken,
           token != "" {
          KeychainHandler.shared.accessToken = token
        }
        if response.status == 200 {
          return TabBarController()
        }
        if response.status == 201 {
          return CertificationViewController()
        }
        return nil
      }
      .asDriver(onErrorJustReturn: nil)

    return Output(isInitialUser: isInitialUser, didLogin: didLogin)
  }

}

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
    let authType: PublishSubject<AuthType>
  }

  struct Output {
    let didLogin: Driver<UIViewController?>
  }

  func transform(input: Input) -> Output {
    let loginService = input.didTapLoginButton
      .flatMap { NetworkService.shared.auth.auth(type: $0.0, token: $0.1) }

    let didLogin = Observable.combineLatest(loginService, input.authType)
      .map { response, auth -> UIViewController? in
        let token = response.data?.token?.tokenResponseDTO
        if let accessToken = token?.accessToken,
           let accessTokenExpiredAt = token?.accessTokenExpiredAt,
           let refreshToken = token?.refreshToken,
           let refreshTokenExpiredAt = token?.refreshTokenExpiredAt,
           accessToken != "" {
          KeychainHandler.shared.accessToken = accessToken
          KeychainHandler.shared.accessTokenExpiredAt = accessTokenExpiredAt
          KeychainHandler.shared.refreshToken = refreshToken
          KeychainHandler.shared.refreshTokenExpiredAt = refreshTokenExpiredAt
          KeychainHandler.shared.userID = response.data?.token?.userID ?? -1
          UserDefaultHandler.shared.userName = response.data?.token?.nickname
          UserDefaultHandler.shared.userImageURL = response.data?.token?.profileURL
        }
        if response.status == 200 {
          return TabBarController()
        }
        if response.status == 201 {
          guard let socialID = response.data?.socialID else { return nil }
          return CertificationViewController(socialID: socialID, socialType: auth.description)
        }
        return nil
      }
      .asDriver(onErrorJustReturn: nil)

    return Output(didLogin: didLogin)
  }

}

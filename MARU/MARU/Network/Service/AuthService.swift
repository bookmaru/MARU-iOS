//
//  AuthService.swift
//  MARU
//
//  Created by 오준현 on 2021/06/25.
//

import Moya
import RxSwift

protocol AuthServiceType {
  func auth(type: AuthType, token: String) -> Observable<BaseReponseType<LoginDAO>>
  func nickname(name: String) -> Observable<BaseReponseType<Int>>
  func information(information: UserInformation) -> Observable<BaseReponseType<SignupToken>>
  func refresh() -> Observable<BaseReponseType<Token>>
  func user() -> Observable<BaseReponseType<User>>
  func report(chat: RealmChat) -> Observable<BaseReponseType<Int>>
  func change(nickname: String, image: UIImage) -> Observable<BaseReponseType<ChangeProfile>>
}

final class AuthService: AuthServiceType {
  private let router = MoyaProvider<AuthRouter>(plugins: [NetworkLoggerPlugin(verbose: false)])

  func change(nickname: String, image: UIImage) -> Observable<BaseReponseType<ChangeProfile>> {
    return router.rx
      .request(.changeProfile(nickname: nickname, image: image))
      .asObservable()
      .map(BaseReponseType<ChangeProfile>.self)
  }

  func auth(type: AuthType, token: String) -> Observable<BaseReponseType<LoginDAO>> {
    return router.rx
      .request(.auth(type: type, token: token))
      .asObservable()
      .map(BaseReponseType<LoginDAO>.self)
  }

  func nickname(name: String) -> Observable<BaseReponseType<Int>> {
    return router.rx
      .request(.nicknameCheck(name))
      .asObservable()
      .map(BaseReponseType<Int>.self)
  }

  func information(information: UserInformation) -> Observable<BaseReponseType<SignupToken>> {
    return router.rx
      .request(.information(information: information))
      .asObservable()
      .map(BaseReponseType<SignupToken>.self)
  }

  func refresh() -> Observable<BaseReponseType<Token>> {
    return router.rx
      .request(.refresh)
      .asObservable()
      .map(BaseReponseType<Token>.self)
  }

  func user() -> Observable<BaseReponseType<User>> {
    return router.rx
      .request(.user)
      .asObservable()
      .map(BaseReponseType<User>.self)
  }

  func report(chat: RealmChat) -> Observable<BaseReponseType<Int>> {
    return router.rx
      .request(.report(chat: chat))
      .asObservable()
      .map(BaseReponseType<Int>.self)
  }
}

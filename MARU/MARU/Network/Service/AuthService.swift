//
//  AuthService.swift
//  MARU
//
//  Created by 오준현 on 2021/06/25.
//

import Moya
import RxSwift

protocol AuthServiceType {
  func auth(type: AuthType, token: String) -> Observable<BaseResponseType<LoginDAO>>
  func nickname(name: String) -> Observable<BaseResponseType<Int>>
  func information(information: UserInformation) -> Observable<BaseResponseType<SignupToken>>
  func refresh() -> Observable<BaseResponseType<Token>>
  func user() -> Observable<BaseResponseType<User>>
  func signOut() -> Observable<BaseResponseType<Int>>
  func logout() -> Observable<BaseResponseType<Int>>
  func report(chat: RealmChat) -> Observable<BaseResponseType<Int>>
  func change(nickname: String, image: UIImage) -> Observable<BaseResponseType<ChangeProfile>>
  func libraryUser() -> Observable<BaseResponseType<User>>
  func myGroup()->Observable<BaseResponseType<MyGroups>>
}

final class AuthService: AuthServiceType {
  private let router = MoyaProvider<AuthRouter>(plugins: [NetworkLoggerPlugin(verbose: true)])

  func change(nickname: String, image: UIImage) -> Observable<BaseResponseType<ChangeProfile>> {
    return router.rx
      .request(.changeProfile(nickname: nickname, image: image))
      .asObservable()
      .map(BaseResponseType<ChangeProfile>.self)
      .catchError()
  }

  func auth(type: AuthType, token: String) -> Observable<BaseResponseType<LoginDAO>> {
    return router.rx
      .request(.auth(type: type, token: token))
      .asObservable()
      .map(BaseResponseType<LoginDAO>.self)
      .catchError()
  }

  func nickname(name: String) -> Observable<BaseResponseType<Int>> {
    return router.rx
      .request(.nicknameCheck(name))
      .asObservable()
      .map(BaseResponseType<Int>.self)
      .catchError()
  }

  func information(information: UserInformation) -> Observable<BaseResponseType<SignupToken>> {
    return router.rx
      .request(.information(information: information))
      .asObservable()
      .map(BaseResponseType<SignupToken>.self)
      .catchError()
  }

  func refresh() -> Observable<BaseResponseType<Token>> {
    return router.rx
      .request(.refresh)
      .asObservable()
      .map(BaseResponseType<Token>.self)
      .catchError()
  }

  func user() -> Observable<BaseResponseType<User>> {
    return router.rx
      .request(.user)
      .asObservable()
      .map(BaseResponseType<User>.self)
      .catchError()
  }

  func signOut() -> Observable<BaseResponseType<Int>> {
    return router.rx
      .request(.signOut)
      .asObservable()
      .map(BaseResponseType<Int>.self)
      .catchError()
  }

  func logout() -> Observable<BaseResponseType<Int>> {
    return router.rx.request(.logout)
      .asObservable()
      .map(BaseResponseType<Int>.self)
      .catchError()
  }

  func report(chat: RealmChat) -> Observable<BaseResponseType<Int>> {
    return router.rx
      .request(.report(chat: chat))
      .asObservable()
      .map(BaseResponseType<Int>.self)
      .catchError()
  }

  func libraryUser() -> Observable<BaseResponseType<User>> {
    return router.rx
      .request(.userProfile)
      .asObservable()
      .map(BaseResponseType<User>.self)
      .catchError()
  }
  func myGroup() -> Observable<BaseResponseType<MyGroups>> {
    return router.rx
      .request(.myGroup)
      .asObservable()
      .map(BaseResponseType<MyGroups>.self)
      .catchError()
  }
}

//
//  AuthService.swift
//  MARU
//
//  Created by 오준현 on 2021/06/25.
//

import Moya
import RxSwift

protocol AuthServiceType {
  func auth(type: AuthType, token: String) -> Observable<BaseReponseType<Auth>>
}

final class AuthService: AuthServiceType {
  private let router = MoyaProvider<AuthRouter>(plugins: [NetworkLoggerPlugin(verbose: true)])

  func auth(type: AuthType, token: String) -> Observable<BaseReponseType<Auth>> {
    return router.rx
      .request(.auth(type: type, token: token))
      .asObservable()
      .map(BaseReponseType<Auth>.self)
  }

  func nickname(name: String) -> Observable<BaseReponseType<Int>> {
    return router.rx
      .request(.nicknameCheck(name))
      .asObservable()
      .map(BaseReponseType.self)
  }

  func information(information: UserInformation) -> Observable<BaseReponseType<Auth>> {
    return router.rx
      .request(.information(information: information))
      .asObservable()
      .map(BaseReponseType<Auth>.self)
  }
}

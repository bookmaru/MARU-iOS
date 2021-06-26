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
  private let router = MoyaProvider<AuthRouter>()

  func auth(type: AuthType, token: String) -> Observable<BaseReponseType<Auth>> {
    return router.rx
      .request(.auth(type: type, token: token))
      .asObservable()
      .map(BaseReponseType<Auth>.self)
  }
}

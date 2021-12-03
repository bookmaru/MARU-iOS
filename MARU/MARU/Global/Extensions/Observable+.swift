//
//  Observable+.swift
//  MARU
//
//  Created by 오준현 on 2021/12/03.
//

import RxSwift

extension Observable {
  func catchError() -> Observable<Element> {
    self.catchError { error in
      print(Date(), error)
      return .empty()
    }
  }
}

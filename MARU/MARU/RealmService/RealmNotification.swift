//
//  RealmNotification.swift
//  MARU
//
//  Created by 오준현 on 2021/09/11.
//

import RealmSwift

class RealmNotification<T: Object> {
  private var token: NotificationToken?
  private var object: T?

  init() { }

  func subscribeRealm(id: Int) {

  }

  private func fetchObjectFromRealm(id: Int) -> T? {
    return RealmService.shared.read()
  }
}

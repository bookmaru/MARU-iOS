//
//  RealmService.swift
//  MARU
//
//  Created by 오준현 on 2021/09/07.
//

import RealmSwift

final class RealmService {
  static var shared = RealmService()

  private let realm: Realm = {
    let config = Realm.Configuration(
      fileURL: Bundle.main.url(forResource: "maru.kr", withExtension: "chat.realm"),
      readOnly: false,
      schemaVersion: 1
    )
    let realm = try! Realm(configuration: config)
    return realm
  }()

  private init() { }

  func write() {

  }

  func read() {

  }
}

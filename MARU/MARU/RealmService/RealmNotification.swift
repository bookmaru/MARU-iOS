//
//  RealmNotification.swift
//  MARU
//
//  Created by 오준현 on 2021/09/11.
//

import RealmSwift
import RxSwift

final class RealmNotification {
  static let shared = RealmNotification()

  private var token: NotificationToken?
  private var object: RealmChat?

  private init() { }

  func subscribeRealm(roomID: Int) {

  }

  func fetchObjectFromRealm(roomID: Int) -> PublishSubject<[RealmChat]> {
    let chatPublisher = PublishSubject<[RealmChat]>()
    token = RealmService.shared.read(roomID).observe { chages in
      switch chages {
      case let .update(chat, _, _, _):
        let chats: [RealmChat] = chat.map { $0 }
        print("asdasd token", chats)
        chatPublisher.onNext(chats)
      default:
        break
      }
    }
    return chatPublisher
  }
}

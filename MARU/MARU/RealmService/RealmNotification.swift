//
//  RealmNotification.swift
//  MARU
//
//  Created by 오준현 on 2021/09/11.
//

import RealmSwift
import RxSwift

final class RealmNotification {
  private var token: NotificationToken?

  init() { }

  func fetchObjectFromRealm(roomID: Int) -> PublishSubject<[RealmChat]> {
    token?.invalidate()
    let chatPublisher = PublishSubject<[RealmChat]>()
    token = RealmService.shared.read(roomID).observe { chages in
      switch chages {
      case let .update(chat, _, _, _):
        let chats: [RealmChat] = chat.map { $0 }
        chatPublisher.onNext(chats)
      default:
        break
      }
    }
    return chatPublisher
  }

  func fetchChatRooms() -> BehaviorSubject<RealmChat?> {
    let chatPublisher = BehaviorSubject<RealmChat?>(value: .init())
    token = RealmService.shared.getChatRoomsLast().observe { chages in
      switch chages {
      case let .update(chats, _, _, _):
        let chatList = chats.map { $0 }.last
        let chat = chatList
        chatPublisher.onNext(chat)
      default:
        break
      }
    }
    return chatPublisher
  }
}

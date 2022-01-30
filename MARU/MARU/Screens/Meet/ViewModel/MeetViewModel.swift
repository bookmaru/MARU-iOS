//
//  MeetViewModel.swift
//  MARU
//
//  Created by 오준현 on 2021/04/05.
//

import RxCocoa
import RxSwift

final class MeetViewModel {

  struct Input {
    let viewDidLoadPublisher: Observable<Void>
  }

  struct Output {
    let group: Driver<[MeetCase]>
  }

  private let realm = RealmNotification()
  private var chatPublisher = BehaviorSubject<RealmChat?>(value: .init())

  func transform(input: Input) -> Output {
    _ = RealmService.shared.findRoomID()

    chatPublisher = realm.fetchChatRooms()

    let group = input.viewDidLoadPublisher
      .flatMap { NetworkService.shared.group.participateList() }
      .map { $0.data.map { $0.groups } }
      .compactMap { $0 }

    let generatedChat = chatPublisher
      .map { chat -> [RealmChat] in
        var initialize = RealmService.shared.getChatRoom()
        initialize = initialize.map { groupChat -> RealmChat in
          if groupChat.roomID == chat?.roomID {
            return chat ?? RealmChat()
          }
          return groupChat
        }
        return initialize
      }

    let generatedGroup = BehaviorSubject
      .combineLatest(group, generatedChat)
      .map { group, chatList -> [GeneratedGroup] in
        let generatedGroup: [GeneratedGroup] = group
          .compactMap { group -> GeneratedGroup in
            if chatList.isEmpty {
              return GeneratedGroup(group: group, message: RealmChat())
            }
            let roomID = group.discussionGroupID
            var index = 0
            for (chatIndex, chat) in chatList.enumerated() where chat.roomID == roomID {
              index = chatIndex
            }
            return GeneratedGroup(group: group, message: chatList[index])
          }
        return generatedGroup
      }

    let output = generatedGroup
      .map { groups -> [MeetCase] in
        var count: Int = 0
        groups.forEach {
          if $0.isLeader {
            count += 1
          }
        }
        if groups.isEmpty {
          return [.empty]
        }
        let meet = groups.map { MeetCase.meet($0) }
        if count < 3 {
          return meet + [.empty]
        }
        return meet
      }
      .asDriver(onErrorJustReturn: [])

    return Output(group: output)
  }
}

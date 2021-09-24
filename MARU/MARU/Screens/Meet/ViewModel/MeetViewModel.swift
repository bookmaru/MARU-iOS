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
    let viewDidLoadPublisher: PublishSubject<Void>
  }

  struct Output {
    let group: Driver<[MeetCase]>
  }

  private let realm = RealmNotification()
  private var chatPublisher = BehaviorSubject<RealmChat?>(value: .init())
  private var initialize: [RealmChat] = []

  func transform(input: Input) -> Output {
    chatPublisher = realm.fetchChatRooms()

    initialize = RealmService.shared.getChatRoom()

    let group = input.viewDidLoadPublisher
      .flatMap { NetworkService.shared.group.participateList() }
      .map { $0.data.map { $0.groups } }
      .compactMap { $0 }

    let generatedChat = chatPublisher
      .map { [weak self] chat -> [RealmChat] in
        guard let self = self else { return [] }
        self.initialize = self.initialize.map { groupChat -> RealmChat in
          if groupChat.roomID == chat?.roomID {
            return chat ?? RealmChat()
          }
          return groupChat
        }
        return self.initialize
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
        if groups.isEmpty {
          return [.empty]
        }
        let meet = groups.map { MeetCase.meet($0) }
        if meet.count < 3 {
          return meet + [.empty]
        }
        return meet
      }
      .asDriver(onErrorJustReturn: [])

    return Output(group: output)
  }
}

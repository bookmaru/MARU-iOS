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
  private var initialize: [RealmChat]

  init() {
    initialize = RealmService.shared.getChatRoom()
  }

  func transform(input: Input) -> Output {
    chatPublisher = realm.fetchChatRooms()

    let group = input.viewDidLoadPublisher
      .debug()
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
      .map { group, chat -> [GeneratedGroup] in
        var generatedGroup: [GeneratedGroup] = []
        group.forEach { group in
          chat.forEach { chat in
            if group.discussionGroupID == chat.roomID {
              generatedGroup.append(GeneratedGroup(group: group, message: chat))
            }
          }
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

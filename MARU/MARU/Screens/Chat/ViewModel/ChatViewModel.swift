//
//  ChatViewModel.swift
//  MARU
//
//  Created by 오준현 on 2021/04/20.
//

import RxCocoa
import RxSwift

enum Chat {
  case message(data: RealmChat)
  case otherProfile(data: RealmChat)
  case otherMessage(data: RealmChat)

  var cellHeight: CGFloat {
    switch self {
    case .message(let data):
      return NSString(string: data.content).boundingRect(
        with: CGSize(width: ScreenSize.width - 150, height: .zero),
        options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
        context: nil
      )
      .height + 18

    case .otherProfile(let data):
      return NSString(string: data.content).boundingRect(
        with: CGSize(width: ScreenSize.width - 150, height: .zero),
        options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
        context: nil
      )
      .height + 18 + 13 + 5.5

    case .otherMessage(let data):
      return NSString(string: data.content).boundingRect(
        with: CGSize(width: ScreenSize.width - 150, height: .zero),
        options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
        context: nil
      )
      .height + 18
    }
  }
}

final class ChatViewModel {
  private let roomIndex: Int
  private let recivePublisher = BehaviorSubject<[RealmChat]>(value: [])
  private let sendPublisher: Observable<String>

  private var prevChatSender: String?
  private let userName = UserDefaultHandler.shared.userName

  let disposeBag = DisposeBag()

  struct Input { }

  struct Output {
    let chat: Driver<[Chat]>
  }

  init(roomIndex: Int, sendPublisher: Observable<String>) {
    self.roomIndex = roomIndex
    self.sendPublisher = sendPublisher

    RealmNotification.shared.fetchObjectFromRealm(roomID: 1)
      .bind(to: self.recivePublisher)
      .disposed(by: disposeBag)

    ChatService.shared.bind(
      roomIndex: roomIndex,
      sendPublisher: sendPublisher
    )
  }

  deinit {
    ChatService.shared.clearMessageDisposeBag()
  }

  func transform(input: Input) -> Output {
    let chat = recivePublisher
      .flatMap { self.chatModelGenerator(chat: $0) }
      .asDriver(onErrorJustReturn: [])

    recivePublisher.onNext(RealmService.shared.oneTimeRead(roomIndex))

    return Output(chat: chat)
  }

  private func chatModelGenerator(chat: [RealmChat]) -> Observable<[Chat]> {
    return .just(chat.map { generator(chat: $0) })
  }

  private func generator(chat: RealmChat) -> Chat {
    if chat.userName == userName {
      prevChatSender = chat.userName
      return .message(data: chat)
    }
    if prevChatSender == chat.userName {
      return .otherMessage(data: chat)
    }
    prevChatSender = chat.userName
    return .otherProfile(data: chat)
  }
}

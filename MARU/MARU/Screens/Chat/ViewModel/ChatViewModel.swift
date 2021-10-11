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
  private let roomID: Int
  private let recivePublisher = BehaviorSubject<[RealmChat]>(value: [])
  private let sendPublisher: Observable<String>

  private var prevChatSender: String?
  private let userName = UserDefaultHandler.shared.userName

  let disposeBag = DisposeBag()

  struct Input {
    let viewWillAppear: Observable<Void>
    let didLongTap: Observable<RealmChat>
    let didTapGroupButton: Observable<Void>
  }

  struct Output {
    let chat: Driver<[Chat]>
    let isReportSuccess: Driver<Bool>
    let isCheckNotice: Driver<Bool>
  }

  private let realm = RealmNotification()

  init(roomID: Int, sendPublisher: Observable<String>) {
    self.roomID = roomID
    self.sendPublisher = sendPublisher

    realm.fetchObjectFromRealm(roomID: roomID)
      .bind(to: recivePublisher)
      .disposed(by: disposeBag)

    ChatService.shared.bind(
      roomID: roomID,
      sendPublisher: sendPublisher
    )
  }

  deinit {
    ChatService.shared.clearMessageDisposeBag()
  }

  func transform(input: Input) -> Output {

    let isCheckNotice = input.viewWillAppear
      .map { UserDefaults.standard.bool(forKey: "room\(self.roomID)") }
      .asDriver(onErrorJustReturn: false)

    let chat = recivePublisher
      .flatMap { self.chatModelGenerator(chat: $0) }
      .asDriver(onErrorJustReturn: [])

    let isReportSuccess = input.didLongTap
      .flatMap { NetworkService.shared.auth.report(chat: $0) }
      .map { $0.status == 201 }
      .asDriver(onErrorJustReturn: false)

    _ = input.didTapGroupButton
      .flatMap { NetworkService.shared.book.addGroup(groupID: self.roomID) }
      .subscribe(onNext: { _ in

      })
      .disposed(by: disposeBag)

    recivePublisher.onNext(RealmService.shared.oneTimeRead(roomID))

    return Output(chat: chat, isReportSuccess: isReportSuccess, isCheckNotice: isCheckNotice)
  }

  private func chatModelGenerator(chat: [RealmChat]) -> Observable<[Chat]> {
    return .just(chat.compactMap { generator(chat: $0) })
  }

  private func generator(chat: RealmChat) -> Chat? {
    if chat.type != "CHAT" {
      return nil
    }
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

//
//  ChatViewModel.swift
//  MARU
//
//  Created by 오준현 on 2021/04/20.
//

import RxCocoa
import RxSwift

struct ChatDTO {
  let profileImage: String?
  let name: String?
  let message: String?
}

enum Chat {
  case message(data: ChatDTO)
  case otherProfile(data: ChatDTO)
  case otherMessage(data: ChatDTO)

  var cellHeight: CGFloat {
    switch self {
    case .message(let data):
      return NSString(string: data.message ?? "").boundingRect(
        with: CGSize(width: ScreenSize.width - 60, height: .zero),
        options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
        context: nil
      )
      .height + 18

    case .otherProfile(let data):
      return NSString(string: data.message ?? "").boundingRect(
        with: CGSize(width: ScreenSize.width - 60, height: .zero),
        options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
        context: nil
      )
      .height + 18 + 13 + 5.5

    case .otherMessage(let data):
      return NSString(string: data.message ?? "").boundingRect(
        with: CGSize(width: ScreenSize.width - 60, height: .zero),
        options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
        context: nil
      )
      .height + 18

    }
  }
}

final class ChatViewModel {

  private let chatService: ChatService
  private let roomIndex: Int
  private let recivePublisher = PublishSubject<ChatDAO>()
  private let messagePublisher: Observable<String>
  let disposeBag = DisposeBag()

  struct Input {

  }

  struct Output {
    let chat: Driver<Chat>
  }

  init(roomIndex: Int, messagePublisher: Observable<String>) {
    self.roomIndex = roomIndex
    self.messagePublisher = messagePublisher
    chatService = ChatService(
      roomIndex: roomIndex,
      messagePublisher: messagePublisher,
      receivePublisher: recivePublisher
    )
  }

  deinit {
    print("ChatViewModel deinit")
  }

  func transform(input: Input) -> Output {
    let chat = recivePublisher
      .map { chat -> Chat in
        if chat.sender == "마루" {
          return .message(data: ChatDTO(profileImage: nil, name: chat.sender, message: chat.content))
        }
        return .otherMessage(data: ChatDTO(profileImage: nil, name: chat.sender, message: chat.content))
      }
      .asDriver(onErrorJustReturn: .message(data: .init(profileImage: nil, name: nil, message: nil)))

    return Output(chat: chat)
  }
}

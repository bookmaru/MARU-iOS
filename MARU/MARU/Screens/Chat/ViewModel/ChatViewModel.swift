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

  private let chatService = ChatService(roomIndex: "1")

  struct Input {

  }

  struct Output {

  }

  init() {
    print("ChatViewModel init")
  }

  deinit {
    print("ChatViewModel deinit")
  }

  func transform(input: Input) -> Output {

    return Output()
  }
}

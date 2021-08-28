//
//  ChatService.swift
//  MARU
//
//  Created by 오준현 on 2021/08/15.
//

import StompClientLib
import RxSwift

final class ChatService {

  private let roomIndex: Int

  private let baseURL = Enviroment.socketURL
  private let socket = StompClientLib()
  private let topic: String
  private let destination: String
  private let message: Observable<String>
  private let receive: PublishSubject<ChatDAO>
  private let disposeBag = DisposeBag()
  private let userName = UserDefaultHandler.shared.userName

  init(
    roomIndex: Int,
    messagePublisher: Observable<String>,
    receivePublisher: PublishSubject<ChatDAO>
  ) {
    self.roomIndex = roomIndex
    self.message = messagePublisher
    self.receive = receivePublisher
    topic = "/topic/public/\(roomIndex)"
    destination = "/app/chat.sendMessage/\(roomIndex)"
    register()

    message.subscribe(onNext: { [weak self] message in
      guard let self = self else { return }
      let chat = ["id": "1", "type": "CHAT", "content": message, "sender": self.userName]
      self.socket.sendJSONForDict(dict: chat as AnyObject, toDestination: self.destination)
    })
    .disposed(by: disposeBag)
  }

  private func register() {
    socket.openSocketWithURLRequest(
      request: NSURLRequest(url: baseURL),
      delegate: self as StompClientLibDelegate
    )
  }
}

extension ChatService: StompClientLibDelegate {
  func stompClient(
    client: StompClientLib!,
    didReceiveMessageWithJSONBody jsonBody: AnyObject?,
    akaStringBody stringBody: String?,
    withHeader header: [String: String]?,
    withDestination destination: String
  ) {
    guard let json = jsonBody as? [String: Any] else { return }

    let chat = ChatDAO(
      chatID: json["id"] as? Int ?? nil,
      type: json["type"] as? String ?? nil,
      content: json["content"] as? String ?? nil,
      sender: json["sender"] as? String ?? nil
    )

    receive.onNext(chat)
  }

  func stompClientDidDisconnect(client: StompClientLib!) {
    dump(client)
  }

  func stompClientDidConnect(client: StompClientLib!) {
    socket.subscribe(destination: topic)
  }

  func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
    print(receiptId)
  }

  func serverDidSendError(
    client: StompClientLib!,
    withErrorMessage description: String,
    detailedErrorMessage message: String?
  ) {
    dump(client)
    print(description)
    dump(message)
  }

  func serverDidSendPing() {
    print("ping")
  }
}

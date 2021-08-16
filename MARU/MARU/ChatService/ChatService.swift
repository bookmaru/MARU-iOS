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

  let baseURL = "ws://3.36.251.65:8081/ws/websocket"
  let socket = StompClientLib()
  let topic: String
  let destination: String
  let message: Observable<String>
  let receive: PublishSubject<ChatDAO>
  let disposeBag = DisposeBag()

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

    message.subscribe(onNext: { message in
      let chat = ["id": "1", "type": "CHAT", "content": message, "sender": "마루"]
      self.socket.sendJSONForDict(dict: chat as AnyObject, toDestination: self.destination)
    })
    .disposed(by: disposeBag)
  }

  private func register() {
    let url = URL(string: baseURL)!
    socket.openSocketWithURLRequest(
      request: NSURLRequest(url: url),
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
    dump(jsonBody)
    dump(stringBody)
    dump(header)
    dump(destination)
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

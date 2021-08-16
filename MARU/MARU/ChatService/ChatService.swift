//
//  ChatService.swift
//  MARU
//
//  Created by 오준현 on 2021/08/15.
//

import StompClientLib
import RxSwift

final class ChatService {

  private let roomIndex: String

  let baseURL = "ws://3.36.251.65:8081/ws/websocket"
  let socket = StompClientLib()
  let topic = "/topic/public/1"
  let destination = "/app/chat.sendMessage/1"

  init(roomIndex: String) {
    self.roomIndex = roomIndex

    register()
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

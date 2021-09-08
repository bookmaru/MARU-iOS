//
//  ChatService.swift
//  MARU
//
//  Created by 오준현 on 2021/08/15.
//

import StompClientLib
import RxSwift

final class ChatService {
  static var shared = ChatService()

  private init() {
    print("chat service init")
    register()
    bindMessage()
  }

  deinit {
    print("chat service deinit")
  }

  func start() { }

  private let baseURL = Enviroment.socketURL
  private let socket = StompClientLib()
  private let message = PublishSubject<String>()
  private let receive = PublishSubject<ChatDAO>()
  private let disposeBag = DisposeBag()
  private let userName = UserDefaultHandler.shared.userName

  private var roomIndex: Int? {
    didSet {
      guard let roomIndex = roomIndex else { return }
      topic = "/topic/public/\(roomIndex)"
      destination = "/app/chat.sendMessage/\(roomIndex)"
    }
  }
  private var destination: String = ""
  private var topic: String = ""
  var messageDisposeBag = DisposeBag()

  private func register() {
    socket.openSocketWithURLRequest(
      request: NSURLRequest(url: baseURL),
      delegate: self as StompClientLibDelegate
    )
  }

  private func bindMessage() {
    message.subscribe(onNext: { [weak self] message in
      guard let self = self else { return }
      let chat = [
        "id": self.roomIndex?.string,
        "type": "CHAT",
        "content": message,
        "sender": self.userName
      ]
      self.socket.sendJSONForDict(
        dict: chat as AnyObject,
        toDestination: self.destination
      )
    })
    .disposed(by: disposeBag)
  }

  private func enrolledRoomSubcribe() {

  }

  func bind(
    roomIndex: Int,
    sendPublisher: Observable<String>
  ) -> PublishSubject<ChatDAO> {
    self.roomIndex = roomIndex

    sendPublisher
      .bind(to: message)
      .disposed(by: messageDisposeBag)

    return receive
  }

  func subscribeRoom(roomIndex: Int) {
    socket.subscribe(destination: "/topic/public/\(roomIndex)")
  }

  func clearMessageDisposeBag() {
    messageDisposeBag = DisposeBag()
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

  func stompClientDidDisconnect(client: StompClientLib!) { }

  func stompClientDidConnect(client: StompClientLib!) {
    enrolledRoomSubcribe()
  }

  func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) { }

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

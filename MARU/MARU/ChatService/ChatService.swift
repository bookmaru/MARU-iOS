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
  var chatID = 1

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
    let roomIDList = RealmService.shared.findRoomID()
    // MARK: 현재 테스트가 불가해서 저장된 roomID가 없으면 1번 방으로 배정
    // TODO: 요 룸 없으면 구독하는것 지우기
    if roomIDList.isEmpty {
      subscribeRoom(roomIndex: 1)
    } else {
      roomIDList.forEach {
        subscribeRoom(roomIndex: $0)
      }
    }
  }

  func bind(
    roomIndex: Int,
    sendPublisher: Observable<String>
  ) {
    self.roomIndex = roomIndex

    sendPublisher
      .bind(to: message)
      .disposed(by: messageDisposeBag)
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

    let realm = RealmChat(
      chatID: chatID,
      roomID: json["id"] as? Int ?? 0,
      type: json["type"] as? String ?? "",
      userName: json["sender"] as? String ?? "",
      userImageURL: json["user_image_url"] as? String ?? "",
      content: json["content"] as? String ?? "",
      time: json["time"] as? String ?? ""
    )
    chatID += 1
    RealmService.shared.write(realm)
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
  ) { }

  func serverDidSendPing() { }
}

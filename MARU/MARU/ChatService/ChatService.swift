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

  private init() { }

  deinit { }

  private let baseURL = Enviroment.socketURL
  private let socket = StompClientLib()
  private let message = PublishSubject<String>()
  private var disposeBag = DisposeBag()
  private let saveChatListRealmPublisher = PublishSubject<Int>()

  private var roomID: Int? {
    didSet {
      guard let roomID = roomID else { return }
      topic = "/topic/public/\(roomID)"
      destination = "/app/chat.sendMessage/\(roomID)"
    }
  }
  private var destination: String = ""
  private var topic: String = ""
  private var messageDisposeBag = DisposeBag()

  func start() {
    register()
    bindMessage()
    bindChatList()
    repeatPing()
  }
}

// MARK: - open method
extension ChatService {
  func userRoomFinder(rooms: [Int]?) {
    guard let rooms = rooms else { return }
    rooms.forEach {
      subscribeRoom(roomID: $0)
    }
  }

  func disconnect() {
    socket.disconnect()
    disposeBag = DisposeBag()
  }

  func reconnect() {
    bindChatList()
    socket.reconnect(
      request: NSURLRequest(url: baseURL),
      delegate: self as StompClientLibDelegate
    )
    enrolledRoomSubcribe()
  }

  func bind(
    roomID: Int,
    sendPublisher: Observable<String>
  ) {
    self.roomID = roomID

    sendPublisher
      .bind(to: message)
      .disposed(by: messageDisposeBag)
  }

  func subscribeRoom(roomID: Int) {
    socket.subscribe(destination: "/topic/public/\(roomID)")
    saveChatListRealmPublisher.onNext(roomID)
    _ = RealmService.shared.findRoomID()
  }

  func unsubscribeRoom(roomID: Int) {
    socket.unsubscribe(destination: "/topic/public/\(roomID)")
    RealmService.shared.deleteRoom(roomID: roomID)
  }

  func clearMessageDisposeBag() {
    messageDisposeBag = DisposeBag()
  }
}

// MARK: - private method
extension ChatService {
  private func register() {
    socket.openSocketWithURLRequest(
      request: NSURLRequest(url: baseURL),
      delegate: self as StompClientLibDelegate
    )
  }

  private func repeatPing() {
    Observable<Int>
      .interval(.seconds(3), scheduler: MainScheduler.instance)
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .subscribe(onNext: { _ in
        self.serverDidSendPing()
      })
      .disposed(by: disposeBag)
  }

  private func bindMessage() {
    message.subscribe(onNext: { [weak self] message in
      guard let self = self,
            let roomID = self.roomID
      else { return }
      let chat: [String: Any] = [
        "chatId": UUID().uuidString,
        "roomId": roomID,
        "userId": KeychainHandler.shared.userID,
        "type": "CHAT",
        "content": message,
        "sender": UserDefaultHandler.shared.userName ?? "",
        "time": self.realTime()
      ]
      self.socket.sendJSONForDict(
        dict: chat as AnyObject,
        toDestination: self.destination
      )
    })
    .disposed(by: messageDisposeBag)
  }

  private func bindChatList() {
    saveChatListRealmPublisher
      .flatMap { NetworkService.shared.group.chatList(roomID: $0) }
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.saveChatRealm(chatList: $0)
      })
      .disposed(by: disposeBag)
  }

  private func enrolledRoomSubcribe() {
    let roomIDList = RealmService.shared.findRoomID()
    roomIDList.forEach {
      subscribeRoom(roomID: $0)
    }
  }

  private func saveChatRealm(chatList: [RealmChat]) {
    chatList.forEach {
      RealmService.shared.write($0)
    }
  }

  private func realTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd.HH:mm:ss"
    return dateFormatter.string(from: Date())
  }

  private func stringToTimeConvertor(string: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd.HH:mm:ss"
    return dateFormatter.date(from: string) ?? Date()
  }
}
// MARK: - 채팅방 입장!
extension ChatService {
  func joinRoom(roomID: Int) {
    socket.subscribe(destination: "/topic/public/\(roomID)")
    saveChatListRealmPublisher.onNext(roomID)
    _ = RealmService.shared.findRoomID()

    let chat: [String: Any] = [
      "chatId": UUID().uuidString,
      "roomId": roomID,
      "userId": KeychainHandler.shared.userID,
      "type": "JOIN",
      "content": "",
      "sender": UserDefaultHandler.shared.userName ?? "",
      "time": self.realTime()
    ]

    let destination = "/app/chat.sendMessage/\(roomID)"

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.socket.sendJSONForDict(
        dict: chat as AnyObject,
        toDestination: destination
      )
    }
  }

  func createRoom(roomID: Int) {
    socket.subscribe(destination: "/topic/public/\(roomID)")
    let chat: [String: Any] = [
      "chatId": UUID().uuidString,
      "roomId": roomID,
      "userId": KeychainHandler.shared.userID,
      "type": "JOIN",
      "content": "",
      "sender": UserDefaultHandler.shared.userName ?? "",
      "time": self.realTime()
    ]

    let destination = "/app/chat.sendMessage/\(roomID)"

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.socket.sendJSONForDict(
        dict: chat as AnyObject,
        toDestination: destination
      )
    }
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
      chatID: json["chatId"] as? String ?? "",
      roomID: json["roomId"] as? Int ?? 0,
      userID: json["userId"] as? Int ?? 0,
      type: json["type"] as? String ?? "",
      userName: json["sender"] as? String ?? "",
      userImageURL: json["userImageUrl"] as? String ?? "",
      content: json["content"] as? String ?? "",
      time: stringToTimeConvertor(string: json["time"] as? String ?? "")
    )
    RealmService.shared.write(realm)
  }

  func stompClientDidDisconnect(client: StompClientLib!) {  }

  func stompClientDidConnect(client: StompClientLib!) { enrolledRoomSubcribe() }

  func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) { }

  func serverDidSendError(
    client: StompClientLib!,
    withErrorMessage description: String,
    detailedErrorMessage message: String?
  ) { }

  func serverDidSendPing() { }
}

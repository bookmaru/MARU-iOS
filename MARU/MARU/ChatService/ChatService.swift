//
//  ChatService.swift
//  MARU
//
//  Created by 오준현 on 2021/08/15.
//

import SocketIO
import RxSwift

final class ChatService {

  private let baseURL: String = "http://3.36.251.65:8081/"
  private let roomIndex: String

  var socket: SocketIOClient
  var manager = SocketManager(
    socketURL: URL(string: "http://3.36.251.65:8081/regiter")!,
    config: [.log(true), .compress]
  )

  init(roomIndex: String) {
    self.roomIndex = roomIndex
    socket = manager.defaultSocket

    socket.connect()

    manager = SocketManager(socketURL: URL(string: baseURL + "oo/aa")!, config: [.log(true), .compress])
    socket = manager.socket(forNamespace: "/")

    socket.connect()
    socket.emit("", "")
  }

}

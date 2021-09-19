//
//  RealmChat.swift
//  MARU
//
//  Created by 오준현 on 2021/09/10.
//

import RealmSwift

class RealmChat: Object, Codable {
  @objc dynamic var chatID: Int = 0
  @objc dynamic var roomID: Int = 0
  @objc dynamic var userID: Int = 0
  @objc dynamic var type: String = ""
  @objc dynamic var userName: String = ""
  @objc dynamic var userImageURL: String = ""
  @objc dynamic var content: String = ""
  @objc dynamic var time: String = ""

  override static func primaryKey() -> String? {
    return "chatID"
  }

  convenience init(
    chatID: Int = 0,
    roomID: Int = 0,
    userID: Int = 0,
    type: String = "CHAT",
    userName: String = "",
    userImageURL: String = "",
    content: String = "",
    time: String = ""
  ) {
    self.init()
    self.chatID = chatID
    self.roomID = roomID
    self.userID = userID
    self.type = type
    self.userName = userName
    self.userImageURL = userImageURL
    self.content = content
    self.time = time
  }
}

//
//  RealmChat.swift
//  MARU
//
//  Created by 오준현 on 2021/09/10.
//

import RealmSwift

class RealmChat: Object, Codable {
  @objc dynamic var chatID: String = ""
  @objc dynamic var roomID: Int = 0
  @objc dynamic var userID: Int = 0
  @objc dynamic var type: String = ""
  @objc dynamic var userName: String = ""
  @objc dynamic var userImageURL: String = ""
  @objc dynamic var content: String = ""
  @objc dynamic var time: Date = Date()

  override static func primaryKey() -> String? {
    return "chatID"
  }

  override init() {
    super.init()
  }

  convenience init(
    chatID: String = "",
    roomID: Int = 0,
    userID: Int = 0,
    type: String = "CHAT",
    userName: String = "",
    userImageURL: String = "",
    content: String = "",
    time: Date = Date()
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

  enum CodingKeys: String, CodingKey {
    case chatID = "chatId"
    case roomID = "roomId"
    case userID = "userId"
    case type
    case userName = "sender"
    case userImageURL = "userImageUrl"
    case content
    case time
  }

  required init(from decoder: Decoder) throws {
    super.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    chatID = try container.decode(String.self, forKey: .chatID)
    roomID = try container.decode(Int.self, forKey: .roomID)
    userID = try container.decode(Int.self, forKey: .userID)
    type = try container.decode(String.self, forKey: .type)
    userName = try container.decode(String.self, forKey: .userName)
    userImageURL = try container.decode(String.self, forKey: .userImageURL)
    content = try container.decode(String.self, forKey: .content)
    let timeString = try container.decode(String.self, forKey: .time)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd.HH:mm:ss"
    time = dateFormatter.date(from: timeString) ?? Date()
  }

}

//
//  RealmChat.swift
//  MARU
//
//  Created by 오준현 on 2021/09/10.
//

import RealmSwift

class RealmChat: Object {
  @objc dynamic var chatID: Int = 0
  @objc dynamic var roomID: Int = 0
  @objc dynamic var type: String = ""
  @objc dynamic var userName: String = ""
  @objc dynamic var userImageURL: String = ""
  @objc dynamic var message: String = ""
  @objc dynamic var time: String = ""
}

//
//  RealmService.swift
//  MARU
//
//  Created by 오준현 on 2021/09/07.
//

import RealmSwift

final class RealmService {
  static var shared = RealmService()

  private let realm: Realm = {
    let realm = try! Realm()
    return realm
  }()

  private var rooms: [Int] = []

  private init() { }

  func write(_ object: RealmChat) {
    do {
      try realm.write {
        realm.create(RealmChat.self, value: object, update: .all)
      }
    } catch {
      print(error)
    }
  }

  func oneTimeRead(_ roomID: Int) -> [RealmChat] {
    let results = realm.objects(RealmChat.self)
      .filter("roomID == \(roomID)")
    let result: [RealmChat] = results.map { $0 }
    return result
  }

  func read(_ roomID: Int) -> Results<RealmChat> {
    let results = realm.objects(RealmChat.self)
      .filter("roomID == \(roomID)")
    return results
  }

  func findRoomID() -> [Int] {
    let result = realm.objects(RealmChat.self)
    var setID = Set<Int>()
    let roomIDs: [Int] = result.map { $0.roomID }
    roomIDs.forEach {
      setID.insert($0)
    }
    rooms = setID.map { $0 }
    return rooms
  }

  func deleteRoom(roomID: Int) {
    let room = realm.objects(RealmChat.self)
      .filter("roomID == \(roomID)")

    try! realm.write {
      realm.delete(room)
    }
  }

  func getChatRoomsLast() -> Results<RealmChat> {
    let filter = NSPredicate(format: "roomID IN %@", rooms)
    let chats = realm.objects(RealmChat.self)
      .filter(filter)
    return chats
  }

  func getChatRoom() -> [RealmChat] {
    var roomsChat: [RealmChat] = []

    rooms.forEach {
      guard let chat = realm.objects(RealmChat.self)
        .filter("roomID == \($0)")
        .last
      else { return }
      roomsChat += [chat]
    }

    return roomsChat
  }
}

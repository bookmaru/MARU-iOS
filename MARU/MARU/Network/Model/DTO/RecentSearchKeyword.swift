//
//  RecentSearchKeyword.swift
//  MARU
//
//  Created by psychehose on 2021/07/18.
//

import RealmSwift

class RecentSearchKeyword: Object {
  @objc dynamic var keyword: String = ""
  @objc dynamic var created = Date()
  override class func primaryKey() -> String? {
    return "keyword"
  }
}

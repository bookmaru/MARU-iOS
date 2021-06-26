//
//  UserDefaultHandler.swift
//  MARU
//
//  Created by 오준현 on 2021/06/22.
//

import Foundation
import UIKit

struct UserDefaultHandler {
  static var shared = UserDefaultHandler()
  private init() {}

  private let user = UserDefaults.standard

  private let isInitialUserKey = "isInitialUser"

  var isInitalUserKey: Bool {
    get {
      return user.bool(forKey: isInitialUserKey)
    }
    set {
      return user.setValue(newValue, forKey: isInitialUserKey)
    }
  }
}
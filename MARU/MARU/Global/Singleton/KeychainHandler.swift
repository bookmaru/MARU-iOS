//
//  KeychainHandler.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

import SwiftKeychainWrapper

struct KeychainHandler {
  static var shared = KeychainHandler()
  private init() {}

  private let keychain = UserDefaults.standard
  private let userIDKey = "userID"
  private let accessTokenKey = "accessToken"
  private let accessTokenExpiredAtKey = "accessTokenExpiredAt"
  private let refreshTokenKey = "refreshToken"
  private let refreshTokenExpiredAtKey = "refreshTokenExpiredAt"
  private let apnsTokenKey = "apnsToken"

  var userID: Int {
    get {
      return keychain.integer(forKey: userIDKey)
    }
    set {
      keychain.set(newValue, forKey: userIDKey)
    }
  }

  var accessToken: String {
    get {
      return keychain.string(forKey: accessTokenKey) ?? "Key is empty"
    }
    set {
      keychain.set(newValue, forKey: accessTokenKey)
    }
  }

  var accessTokenExpiredAt: String {
    get {
      return keychain.string(forKey: accessTokenExpiredAtKey) ?? "Key is empty"
    }
    set {
      keychain.set(newValue, forKey: accessTokenExpiredAtKey)
    }
  }

  var refreshToken: String {
    get {
      return keychain.string(forKey: refreshTokenKey) ?? "Key is empty"
    }
    set {
      keychain.set(newValue, forKey: refreshTokenKey)
    }
  }

  var refreshTokenExpiredAt: String {
    get {
      return keychain.string(forKey: refreshTokenExpiredAtKey) ?? "Key is empty"
    }
    set {
      keychain.set(newValue, forKey: refreshTokenExpiredAtKey)
    }
  }

  var apnsToken: String {
    get {
      return keychain.string(forKey: apnsTokenKey) ?? "Key is empty"
    }
    set {
      keychain.set(newValue, forKey: apnsTokenKey)
    }
  }

  func logout() {
    removeAllKeys()
  }

  func removeAllKeys() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
        defaults.removeObject(forKey: key)
    }
  }

}

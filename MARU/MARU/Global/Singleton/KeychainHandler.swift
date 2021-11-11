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

  private let keychain = KeychainWrapper.standard
  private let userIDKey = "userID"
  private let accessTokenKey = "accessToken"
  private let accessTokenExpiredAtKey = "accessTokenExpiredAt"
  private let refreshTokenKey = "refreshToken"
  private let refreshTokenExpiredAtKey = "refreshTokenExpiredAt"
  private let apnsTokenKey = "apnsToken"

  var userID: Int {
    get {
      return keychain.integer(forKey: userIDKey) ?? -1
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
    keychain.remove(forKey: KeychainWrapper.Key(rawValue: accessTokenKey))
    keychain.remove(forKey: KeychainWrapper.Key(rawValue: accessTokenExpiredAtKey))
    keychain.remove(forKey: KeychainWrapper.Key(rawValue: refreshTokenKey))
    keychain.remove(forKey: KeychainWrapper.Key(rawValue: refreshTokenExpiredAtKey))
    UserDefaultHandler.shared.userName = nil
    UserDefaultHandler.shared.userImageURL = nil
  }

  func removeAllKeys() {
    keychain.removeAllKeys()
  }

}

//
//  KeychainHandler.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

import SwiftKeychainWrapper

struct KeychainHandler {
    static var shared = KeychainHandler()
    init() {}

    private let keychain = KeychainWrapper.standard
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"

    var accessToken: String {
        get {
            return keychain.string(forKey: accessTokenKey) ?? "Key is empty"
        }
        set {
            keychain.set(newValue, forKey: accessTokenKey)
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

    func logout() {
        keychain.remove(forKey: KeychainWrapper.Key(rawValue: accessTokenKey))
        keychain.remove(forKey: KeychainWrapper.Key(rawValue: refreshTokenKey))
    }

    func removeAllKeys() {
        keychain.removeAllKeys()
    }

}

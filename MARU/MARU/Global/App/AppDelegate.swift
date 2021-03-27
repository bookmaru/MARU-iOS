//
//  AppDelegate.swift
//  MARU
//
//  Created by 오준현 on 2021/03/26.
//

import UIKit

import Firebase
#if DEBUG
import Gedatsu
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    var filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
    #if DEBUG
    Gedatsu.open()
    filePath = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")
    #endif
    guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)
      else { return true }
    FirebaseApp.configure(options: fileopts)

    return true
  }

  // MARK: - UISceneSession Lifecycle

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration",
                                sessionRole: connectingSceneSession.role)
  }

  func application(
    _ application: UIApplication,
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) {

  }

}

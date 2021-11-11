//
//  AppDelegate.swift
//  MARU
//
//  Created by 오준현 on 2021/03/26.
//

import UIKit
import UserNotifications

import Firebase
import KakaoSDKCommon
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
    guard let fileopts = FirebaseOptions(contentsOfFile: filePath!) else { return true }
    FirebaseApp.configure(options: fileopts)
    KakaoSDKCommon.initSDK(appKey: "887e05e96dc176857e11b18c6bf97969")
    ChatService.shared.start()
    Messaging.messaging().delegate = self

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

extension AppDelegate: MessagingDelegate {
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    guard let token = fcmToken else { return }
    KeychainHandler.shared.apnsToken = token
    let dataDict: [String: String] = ["token": token]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
  }

  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
  }

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any]
  ) {

  }

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult
    ) -> Void) {
    completionHandler(UIBackgroundFetchResult.newData)
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    let userInfo = notification.request.content.userInfo
    completionHandler([[.sound, .badge]])
  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
}

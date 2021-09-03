//
//  TabBarController.swift
//  MARU
//
//  Created by 오준현 on 2021/04/03.
//

import UIKit

final class TabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

    tabbar()
    clearShadow()
    tabBar.layer.applyShadow(color: .black, alpha: 0.2, shadowX: 0, shadowY: 0, blur: 4)
  }
}

extension TabBarController {
  private func tabbar() {
    let mainView = MainViewController()
    let mainViewTabItem = UITabBarItem(
      title: "메인",
      image: Image.mainTabbarHome,
      selectedImage: Image.mainTabbarHomeSelected
    )
    mainView.tabBarItem = mainViewTabItem
    let mainViewController = UINavigationController(rootViewController: mainView)

    let meetView = MeetViewController()
    let meetViewTabItem = UITabBarItem(
      title: "모임",
      image: Image.mainTabbarMoim,
      selectedImage: Image.mainTabbarMoimSelected
    )
    meetView.tabBarItem = meetViewTabItem
    let meetViewController = UINavigationController(rootViewController: meetView)

    let libraryView = MyLibraryViewController()
    let libraryViewTabItem = UITabBarItem(
      title: "서재",
      image: Image.mainTabbarBook,
      selectedImage: Image.mainTabbarBookSelected
    )
    libraryView.tabBarItem = libraryViewTabItem
    let libraryViewController = UINavigationController(rootViewController: libraryView)

    viewControllers = [mainViewController, meetViewController, libraryViewController]
  }

  private func clearShadow() {
    UITabBar.appearance().shadowImage = UIImage()
    UITabBar.appearance().backgroundImage = UIImage()
    UITabBar.appearance().backgroundColor = UIColor.white
    UITabBar.appearance().layer.borderWidth = 0.0
  }
}

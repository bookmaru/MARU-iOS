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
  }
}

extension TabBarController {
  private func tabbar() {
    let mainView = MainViewController()
    let mainViewTabItem = UITabBarItem(title: "메인",
                                       image: UIImage(),
                                       selectedImage: UIImage())
    mainView.tabBarItem = mainViewTabItem
    let mainViewController = UINavigationController(rootViewController: mainView)

    let meetView = MeetViewController()
    let meetViewTabItem = UITabBarItem(title: "모임",
                                       image: UIImage(),
                                       selectedImage: UIImage())
    meetView.tabBarItem = meetViewTabItem
    let meetViewController = UINavigationController(rootViewController: meetView)

    let libraryView = LibraryViewController()
    let libraryViewTabItem = UITabBarItem(title: "서재",
                                          image: UIImage(),
                                          selectedImage: UIImage())
    libraryView.tabBarItem = libraryViewTabItem
    let libraryViewController = UINavigationController(rootViewController: libraryView)

    viewControllers = [mainViewController, meetViewController, libraryViewController]
  }
}

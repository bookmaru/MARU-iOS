//
//  SplashViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

import UIKit

final class SplashViewController: BaseViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    print(Enviroment.baseURL ?? "")

  }
}

extension SplashViewController: ViewControllerType {
  func bind() {

  }

  func layout() {

  }
}

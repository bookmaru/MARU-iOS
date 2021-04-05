//
//  SplashViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

import UIKit

import Then

final class SplashViewController: BaseViewController {

  private let imageView = UIImageView()

  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
    bind()
  }
}

extension SplashViewController: ViewControllerType {
  func bind() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.moveTo()
    }
  }

  func layout() {
    view.backgroundColor = UIColor(red: 65/255, green: 105/255, blue: 225/255, alpha: 1)
    view.add(imageView)
    imageView.snp.makeConstraints {
      $0.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
      $0.width.equalTo(86)
      $0.height.equalTo(117)
    }
    imageView.image = UIImage(named: "loginLogo")
  }
}

extension SplashViewController {
  private func moveTo() {
    let tab = TabBarController()
    tab.modalPresentationStyle = .overFullScreen
    present(tab, animated: false, completion: nil)
  }
}

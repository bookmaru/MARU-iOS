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
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.moveTo()
      ChatService.shared.subscribeRoom(roomIndex: 1)
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
    imageView.image = Image.loginLogo
  }
}

extension SplashViewController {
  private func moveTo() {
    let viewController = tokenCalculate()
    viewController.modalPresentationStyle = .fullScreen
    if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
      delegate.window?.rootViewController = viewController
    }
    present(viewController, animated: false)
  }

  private func tokenCalculate() -> UIViewController {
    if KeychainHandler.shared.accessToken != "Key is empty",
       KeychainHandler.shared.accessTokenExpiredAt != "Key is empty",
       !KeychainHandler.shared.accessTokenExpiredAt.date.isExpired {
      return TabBarController()
    }
    if KeychainHandler.shared.accessTokenExpiredAt != "Key is empty",
       !KeychainHandler.shared.accessTokenExpiredAt.date.isExpired {
      var viewController: UIViewController = OnboardingViewController()
      NetworkService.shared.auth.refresh()
        .subscribe(onNext: { response in
          let token = response.data?.token
          if let accessToken = token?.tokenResponseDTO.accessToken,
             let accessTokenExpiredAt = token?.tokenResponseDTO.accessTokenExpiredAt,
             let refreshToken = token?.tokenResponseDTO.refreshToken,
             let refreshTokenExpiredAt = token?.tokenResponseDTO.refreshTokenExpiredAt,
             accessToken != "" {
            KeychainHandler.shared.accessToken = accessToken
            KeychainHandler.shared.accessTokenExpiredAt = accessTokenExpiredAt
            KeychainHandler.shared.refreshToken = refreshToken
            KeychainHandler.shared.refreshTokenExpiredAt = refreshTokenExpiredAt
          }
          if response.status == 200 {
            viewController = TabBarController()
          } else {
            viewController = OnboardingViewController()
          }
        })
        .disposed(by: disposeBag)
      return viewController
    }
    if KeychainHandler.shared.refreshToken != "Key is empty",
       KeychainHandler.shared.refreshTokenExpiredAt != "Key is empty",
       !KeychainHandler.shared.refreshTokenExpiredAt.date.isExpired {
      return OnboardingViewController()
    }
    return OnboardingViewController()
  }
}

//
//  ProfileChangeViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/08.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class ProfileChangeViewController: UIViewController {
  private let exitButton = UIButton().then {
    $0.setImage(Image.group1011, for: .normal)
    $0.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
  }

  private let submitButton = UIButton().then {
    $0.setTitle("완료", for: .normal)
    $0.setTitleColor(.subText, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
    // MARK: - 완료버튼 누르면 어디로?
  }
  private let profileImageView = UIImageView().then {
    $0.image = Image.group1029
    $0.layer.cornerRadius = 38
    $0.layer.masksToBounds = true
  }

  private let changeProfileButton = UIButton().then {
    $0.setTitle("프로필 사진 변경하기", for: .normal)
    $0.setTitleColor(.mainBlue, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
  }

  private let nicknameGuideLabel = UILabel().then {
    $0.text = "닉네임"
    $0.font = .systemFont(ofSize: 14, weight: .bold)
  }

  private let asteriskLabel = UILabel().then {
    $0.textColor = .negative
    $0.text = "*"
  }

  private let nicknameTextField  = UITextField().then {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.placeholder = "닉네임을 입력하세요."
  }

  private let nicknameCheckLabel = UILabel().then {
    $0.textColor = .subText
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.isHidden = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  private func render() {
    view.backgroundColor = .white
    view.adds([
      exitButton,
      submitButton,
      profileImageView,
      changeProfileButton,
      nicknameGuideLabel,
      asteriskLabel,
      nicknameTextField,
      nicknameCheckLabel
    ])

    exitButton.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
      make.leading.equalTo(view.safeAreaLayoutGuide).offset(21)
      make.size.equalTo(40)
    }

    submitButton.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
      make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
      make.width.equalTo(21)
    }

    profileImageView.snp.makeConstraints { make in
      make.top.equalTo(exitButton.snp.bottom).offset(0)
      make.centerX.equalToSuperview()
      make.size.equalTo(75)
    }
  }
}

extension ProfileChangeViewController {
  @objc func didTapExitButton() {
    self.dismiss(animated: true, completion: nil)
  }
}

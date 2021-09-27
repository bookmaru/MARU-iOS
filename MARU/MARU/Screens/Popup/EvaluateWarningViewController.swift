//
//  EvaluateWarningViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/27.
//

import UIKit

import RxCocoa
import RxSwift

final class EvaluateWarningViewController: UIViewController {
  private let popUpView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 9
    $0.layer.masksToBounds = true
  }

  private let warningLabel = UILabel().then {
    $0.text = "내가 개설한 모임이에요!"
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 18, weight: .bold)
  }

  private let stateImageView = UIImageView().then {
    $0.layer.masksToBounds = true
    $0.image = Image.uSick
  }

  private let stateLabel = UILabel().then {
    let text = "내가 개설한 모임은 자체 평가할 수 없어요."
    let attributeString = NSMutableAttributedString(string: text)
    let font = UIFont.systemFont(ofSize: 13, weight: .bold)
    attributeString.addAttribute(.font, value: font, range: (text as NSString).range(of: "자체 평가"))
    $0.attributedText = attributeString
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 13, weight: .regular)
  }

  private let submitButton = UIButton().then {
    $0.backgroundColor = .lightGray
    $0.isEnabled = false
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    $0.setTitle("확인", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }
}

extension EvaluateWarningViewController {

  private func render() {
    view.backgroundColor = .black.withAlphaComponent(0.7)
    view.add(popUpView)
    popUpView.adds([
      warningLabel,
      stateImageView,
      stateLabel,
      submitButton
    ])
    popUpView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview()
      make.height.equalTo(220)
      make.width.equalTo(252)
    }
    warningLabel.snp.makeConstraints { make in
      make.leading.equalTo(popUpView).offset(56)
      make.top.equalTo(popUpView).offset(20)
    }
    stateImageView.snp.makeConstraints { make in
      make.leading.equalTo(popUpView).offset(108)
      make.top.equalTo(warningLabel.snp.bottom).offset(20)
      make.size.equalTo(40)
    }
    stateLabel.snp.makeConstraints { make in
      make.leading.equalTo(popUpView).offset(18)
      make.centerX.equalTo(popUpView)
      make.top.equalTo(stateImageView.snp.bottom).offset(17)
    }
    submitButton.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
  @objc private func didTapSubmitButton() {
    dismiss(animated: true, completion: nil)
  }
}

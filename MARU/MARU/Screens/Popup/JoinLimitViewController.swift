//
//  JoinLimitViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/12/13.
//

import UIKit
import RxCocoa
import RxSwift

class JoinLimitViewController: UIViewController {

  private let popUpView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 9
    $0.layer.masksToBounds = true
  }

  private let stateImageView = UIImageView().then {
    $0.layer.masksToBounds = true
  }

  private let mainTextLabel = UILabel().then {
    $0.text = "모임을 열 수 있는 개수가 초과되었어요!"
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 13, weight: .regular)
  }

  private let stateLabel = UILabel().then {
    $0.text = "더 이상 모임을 개설할 수 없어요."
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 13, weight: .regular)
  }

  private let submitButton = UIButton().then {
    $0.backgroundColor = .mainBlue
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    $0.setTitle("확인", for: .normal)
    $0.setTitleColor(.white, for: .normal)
  }

  let disposeBag =  DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    render()
  }

  private func bind() {
    submitButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
  }

  private func render() {
    view.backgroundColor = .black.withAlphaComponent(0.7)
    view.add(popUpView)
    popUpView.adds([
      stateImageView,
      mainTextLabel,
      stateLabel,
      submitButton
    ])

    popUpView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(200)
      make.height.equalTo(220)
      make.width.equalTo(252)
    }

    stateImageView.snp.makeConstraints { make in
      make.centerX.equalTo(popUpView)
      make.leading.equalTo(popUpView).offset(100)
      make.top.equalTo(popUpView).offset(20)
      make.size.equalTo(45)
    }

    mainTextLabel.snp.makeConstraints { make in
      make.centerX.equalTo(stateImageView)
      make.leading.equalTo(popUpView).offset(30)
      make.top.equalTo(stateImageView.snp.bottom).offset(20)
    }

    stateLabel.snp.makeConstraints { make in
      make.top.equalTo(mainTextLabel.snp.bottom).offset(6)
      make.leading.equalTo(popUpView).offset(48)
    }

    submitButton.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
  }
}

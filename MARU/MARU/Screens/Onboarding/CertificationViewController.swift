//
//  CertificationViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/06/26.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import DuctTape

final class CertificationViewController: BaseViewController {

  private let maruLogoImageView = UIImageView(image: Image.maruBlueLogo)
  private let guideLabel: UILabel = UILabel().ductTape
    .font(.systemFont(ofSize: 14, weight: .bold))
    .text("서비스 이용 약관 확인 및 동의")
  private let subGuideLabel: UILabel = UILabel().ductTape
    .font(.systemFont(ofSize: 10, weight: .medium))
    .text("마루가 더 나은 서비스 제공을 위해 달려가고 있어요 🏃")
  private let nicknameLabel: UILabel = UILabel().ductTape
    .font(.systemFont(ofSize: 14, weight: .bold))
    .text("닉네임")
  private let nicknameNecessaryLabel: UILabel = UILabel().ductTape
    .font(.systemFont(ofSize: 14, weight: .bold))
    .text("*")
    .textColor(.negative)
  private let nicknameContainerView: UIView = UIView()
  private let nicknameTextField: UITextField = UITextField().ductTape
    .font(.systemFont(ofSize: 10, weight: .semibold))
    .placeholder("13글자 이하의 닉네임을 입력해주세요.")
    .textColor(.subText)
  private let genderLabel: UILabel = UILabel().ductTape
    .font(.systemFont(ofSize: 14, weight: .bold))
    .text("성별")
  private let genderChoiceLabel: UILabel = UILabel().ductTape
    .font(.systemFont(ofSize: 10, weight: .semibold))
    .text("(선택)")
    .textColor(.subText)
  private let maleButton: UIButton = UIButton().then {
    $0.setTitle("남자", for: .normal)
    $0.setTitleColor(.subText, for: .normal)
    $0.setTitleColor(.mainBlue, for: .selected)
  }
  private let femaleButton: UIButton = UIButton()
  private let bornYearLabel: UILabel = UILabel().ductTape
    .font(.systemFont(ofSize: 14, weight: .bold))
    .text("태어난 년도")
  private let bornYearChoiceLabel: UILabel = UILabel().ductTape
    .font(.systemFont(ofSize: 10, weight: .semibold))
    .text("(선택)")
    .textColor(.subText)
  private let bornYearPicker: UIPickerView = UIPickerView()
  private let submitButton: UIButton = UIButton()

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    maleButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.maleButton.isSelected = !self.maleButton.isSelected
        if self.maleButton.isSelected {
          self.maleButton.layer.borderColor = UIColor.mainBlue.cgColor
        } else {
          self.maleButton.layer.borderColor = UIColor.subText.cgColor
        }
      })
      .disposed(by: disposeBag)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension CertificationViewController {
  private func render() {
    view.adds([
      maruLogoImageView,
      guideLabel,
      subGuideLabel,
      nicknameLabel,
      nicknameNecessaryLabel,
      nicknameContainerView,
      nicknameTextField,
      genderLabel,
      genderChoiceLabel,
      maleButton,
      femaleButton,
      bornYearLabel,
      bornYearChoiceLabel,
      bornYearPicker,
      submitButton
    ])
    maruLogoImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-309 + 63)
      $0.size.equalTo(CGSize(width: 36, height: 56))
    }
    guideLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(maruLogoImageView.snp.bottom).offset(16)
    }
    subGuideLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(guideLabel.snp.bottom).offset(7)
    }
    nicknameContainerView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(29)
      $0.trailing.equalToSuperview().offset(-29)
      $0.top.equalTo(subGuideLabel.snp.bottom).offset(72)
      $0.height.equalTo(32)
    }
    nicknameContainerView.layer.borderColor = UIColor.subText.cgColor
    nicknameContainerView.layer.borderWidth = 0.5
    nicknameContainerView.layer.cornerRadius = 5
    nicknameTextField.snp.makeConstraints {
      $0.edges.equalTo(nicknameContainerView).inset(UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12))
    }
    nicknameLabel.snp.makeConstraints {
      $0.top.equalTo(subGuideLabel.snp.bottom).offset(46)
      $0.leading.equalTo(nicknameContainerView.snp.leading).offset(9)
    }
    nicknameNecessaryLabel.snp.makeConstraints {
      $0.leading.equalTo(nicknameLabel.snp.trailing)
      $0.top.equalTo(subGuideLabel.snp.bottom).offset(38)
    }
    genderLabel.snp.makeConstraints {
      $0.leading.equalTo(nicknameLabel)
      $0.top.equalTo(nicknameContainerView.snp.bottom).offset(32)
    }
    genderChoiceLabel.snp.makeConstraints {
      $0.leading.equalTo(genderLabel.snp.trailing).offset(3)
      $0.bottom.equalTo(genderLabel.snp.bottom)
    }
    maleButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(47)
      $0.trailing.equalTo(view.snp.centerX).offset(2)
      $0.height.equalTo(32)
      $0.top.equalTo(genderLabel.snp.bottom).offset(10)
    }
    maleButton.layer.borderColor = UIColor.subText.cgColor
    maleButton.layer.borderWidth = 0.5
    maleButton.layer.cornerRadius = 5
  }
}

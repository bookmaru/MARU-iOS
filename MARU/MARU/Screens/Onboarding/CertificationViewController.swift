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

  private let maruLogoImageView = UIImageView(image: Image.appIcon)
  private let guideLabel: UILabel = UILabel().ductTape
    .font(.systemFont(ofSize: 14, weight: .bold))
    .text("서비스 이용 약관 확인 및 동의")
  private let subGuideLabel: UILabel = UILabel().ductTape
    .font(.systemFont(ofSize: 10, weight: .medium))
    .text("마루가 더 나은 서비스 제공을 위해 달려가고 있어요 🏃")
  private let nicknameLabel: UILabel = UILabel().ductTape
    .font(.systemFont(ofSize: 14, weight: .bold))
    .text("닉네임")
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
  private let maleButton: UIButton = UIButton()
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
    render()
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
      $0.top.equalToSuperview().offset(64)
      $0.size.equalTo(CGSize(width: 36, height: 56))
    }
  }
}

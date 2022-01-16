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

final class CertificationViewController: BaseViewController {

  private let maruLogoImageView = UIImageView(image: Image.maruBlueLogo)
  private let guideLabel: UILabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15, weight: .bold)
    $0.text = "마루가 더 나은 서비스 제공을 위해 달려가고 있어요!"
  }
  private let subGuideLabel: UILabel = UILabel().then {
    $0.font = .systemFont(ofSize: 11, weight: .medium)
    $0.text = """
      계속 진행하면 MARU의 서비스 약관, 개인정보보호정책에
      동의한 것으로 간주됩니다.
      """
    $0.textColor = .subText
    $0.numberOfLines = 2
  }
  private let nicknameLabel: UILabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .bold)
    $0.text = "닉네임"
  }
  private let nicknameNecessaryLabel: UILabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .bold)
    $0.text = "*"
    $0.textColor = .negative
  }
  private let nicknameContainerView: UIView = UIView()
  private let nicknameTextField: UITextField = UITextField().then {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.placeholder = "13글자 이하의 닉네임을 입력해주세요."
  }
  private let nicknameResponseLabel: UILabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = .subText
    $0.isHidden = true
  }
  private let genderLabel: UILabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .bold)
    $0.text = "성별"
  }
  private let genderChoiceLabel: UILabel = UILabel().then {
    $0.font = .systemFont(ofSize: 10, weight: .semibold)
    $0.text = "(선택)"
    $0.textColor = .subText
  }
  private let maleButton: GenderRadioButton = GenderRadioButton(title: "남자")
  private let femaleButton: GenderRadioButton = GenderRadioButton(title: "여자")
  private let bornYearLabel: UILabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .bold)
    $0.text = "태어난 년도"
  }
  private let bornYearChoiceLabel: UILabel = UILabel().then {
    $0.font = .systemFont(ofSize: 10, weight: .semibold)
    $0.text = "(선택)"
    $0.textColor = .subText
  }
  private let bornYearPicker: UIPickerView = UIPickerView()
  private let submitButton: SubmitButton = SubmitButton(title: "회원가입").then {
    $0.backgroundColor = .subText
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    $0.isEnabled = false
  }

  private var years: [Int] = []

  private var userInformation: UserInformation

  init(socialID: String, socialType: String) {
    self.userInformation = UserInformation(
      birth: nil,
      gender: nil,
      nickname: "",
      socialID: socialID,
      socialType: socialType
    )
    super.init()
    self.years = [Int](1900...calculateYear())
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    bind()
    pickerView()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  private func pickerView() {
    bornYearPicker.delegate = self
    bornYearPicker.dataSource = self
    bornYearPicker.selectRow(calculateYear() - 1900 - 24, inComponent: 0, animated: false)
  }

  private func bind() {
    buttonBind()

    nicknameTextField.rx.text
      .do { [weak self] text in
        guard let self = self,
              let text = text
        else { return }
        if text.count == 0 {
          self.nicknameResponseLabel.isHidden = true
          self.submitButton.isSelected = false
          self.submitButton.isEnabled = false
        } else if text.count > 13 {
          self.nicknameResponseLabel.isHidden = false
          self.nicknameResponseLabel.textColor = .negative
          self.nicknameResponseLabel.text = "13자리 이하의 닉네임만 설정가능합니다."
          self.submitButton.isSelected = false
          self.submitButton.isEnabled = false
        } else {
          self.nicknameResponseLabel.isHidden = false
        }
      }
      .filter { text -> Bool in
        guard let count = text?.count else { return false }
        if count != 0 && count < 13 { return true }
        return false
      }
      .flatMap { NetworkService.shared.auth.nickname(name: $0 ?? "").map { $0.status } }
      .subscribe(onNext: { [weak self] statusCode in
        guard let self = self else { return }
        if statusCode == 200 || statusCode == 201 {
          self.nicknameResponseLabel.textColor = .subText
          self.nicknameResponseLabel.text = "사용 가능한 닉네임입니다."
          self.submitButton.isSelected = true
          self.submitButton.isEnabled = true
          self.userInformation.nickname = self.nicknameTextField.text ?? ""
        } else {
          self.nicknameResponseLabel.textColor = .negative
          self.nicknameResponseLabel.text = "이미 존재하는 이름입니다."
          self.submitButton.isSelected = false
          self.submitButton.isEnabled = false
        }
      })
      .disposed(by: disposeBag)
  }

  private func buttonBind() {
    maleButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.maleButton.isSelected = !self.maleButton.isSelected
        self.femaleButton.isSelected = !self.maleButton.isSelected
        self.userInformation.gender = "남자"
      })
      .disposed(by: disposeBag)

    femaleButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.femaleButton.isSelected = !self.femaleButton.isSelected
        self.maleButton.isSelected = !self.femaleButton.isSelected
        self.userInformation.gender = "여자"
      })
      .disposed(by: disposeBag)

    submitButton.rx.tap
      .flatMap { NetworkService.shared.auth.information(information: self.userInformation) }
      .subscribe(onNext: { response in
        let token = response.data?.signup.tokens
        if let accessToken = token?.accessToken,
           let accessTokenExpiredAt = token?.accessTokenExpiredAt,
           let refreshToken = token?.refreshToken,
           let refreshTokenExpiredAt = token?.refreshTokenExpiredAt {
          KeychainHandler.shared.accessToken = "Bearer \(accessToken)"
          KeychainHandler.shared.accessTokenExpiredAt = accessTokenExpiredAt
          KeychainHandler.shared.refreshToken = refreshToken
          KeychainHandler.shared.refreshTokenExpiredAt = refreshTokenExpiredAt
          KeychainHandler.shared.userID = response.data?.signup.userID ?? -1
          UserDefaultHandler.shared.userName = self.userInformation.nickname
        }
        if response.status == 200 || response.status == 201 {
          let viewController = TabBarController()
          viewController.modalPresentationStyle = .fullScreen
          if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            delegate.window?.rootViewController = viewController
          }
          self.present(viewController, animated: false)
        }
      })
      .disposed(by: disposeBag)
  }

  private func calculateYear() -> Int {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter.string(from: Date()).intValue
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
      nicknameResponseLabel,
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
      $0.leading.equalToSuperview().offset(28)
      $0.top.equalToSuperview().offset(62.calculatedHeight)
      $0.size.equalTo(CGSize(width: 36, height: 56))
    }
    guideLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(maruLogoImageView.snp.bottom).offset(16)
    }
    subGuideLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(guideLabel.snp.bottom).offset(6)
    }
    nicknameContainerView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalTo(subGuideLabel.snp.bottom).offset(58)
      $0.height.equalTo(38)
    }
    nicknameContainerView.layer.borderColor = UIColor.subText.cgColor
    nicknameContainerView.layer.borderWidth = 0.5
    nicknameContainerView.layer.cornerRadius = 5
    nicknameTextField.snp.makeConstraints {
      $0.edges.equalTo(nicknameContainerView)
        .inset(UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12))
    }
    nicknameLabel.snp.makeConstraints {
      $0.top.equalTo(subGuideLabel.snp.bottom).offset(30)
      $0.leading.equalTo(nicknameContainerView.snp.leading)
    }
    nicknameNecessaryLabel.snp.makeConstraints {
      $0.leading.equalTo(nicknameLabel.snp.trailing)
      $0.top.equalTo(subGuideLabel.snp.bottom).offset(28)
    }
    nicknameResponseLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameContainerView.snp.bottom).offset(4)
      $0.leading.equalTo(nicknameTextField)
    }
    genderLabel.snp.makeConstraints {
      $0.leading.equalTo(nicknameLabel).offset(2)
      $0.top.equalTo(nicknameContainerView.snp.bottom).offset(32)
    }
    genderChoiceLabel.snp.makeConstraints {
      $0.leading.equalTo(genderLabel.snp.trailing).offset(3)
      $0.bottom.equalTo(genderLabel.snp.bottom)
    }
    maleButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalTo(view.snp.centerX).offset(2)
      $0.height.equalTo(32)
      $0.top.equalTo(genderLabel.snp.bottom).offset(10)
    }
    femaleButton.snp.makeConstraints {
      $0.leading.equalTo(maleButton.snp.trailing).offset(4)
      $0.top.bottom.width.equalTo(maleButton)
    }
    bornYearLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(maleButton.snp.bottom).offset(38)
    }
    bornYearChoiceLabel.snp.makeConstraints {
      $0.leading.equalTo(bornYearLabel.snp.trailing)
      $0.bottom.equalTo(bornYearLabel)
    }
    bornYearPicker.snp.makeConstraints {
      $0.top.equalTo(bornYearLabel.snp.bottom)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(200)
    }
    submitButton.snp.makeConstraints {
      $0.height.equalTo(60)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}

extension CertificationViewController: UIPickerViewDelegate { }

extension CertificationViewController: UIPickerViewDataSource {
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return years.count
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return years[row].string
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    userInformation.birth = years[row]
  }
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
}

private class GenderRadioButton: UIButton {

  override var isSelected: Bool {
    didSet {
      if isSelected {
        backgroundColor = .mainBlue
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
      } else {
        backgroundColor = .white
        layer.borderColor = UIColor.subText.cgColor
        layer.borderWidth = 0.5
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: .zero)
    setTitleColor(.white, for: .selected)
    setTitleColor(.subText, for: .normal)
    layer.borderColor = UIColor.subText.cgColor
    layer.borderWidth = 0.5
    layer.cornerRadius = 3
    titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
  }

  convenience init(title: String) {
    self.init()

    setTitle(title, for: .normal)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private class SubmitButton: UIButton {
  override var isSelected: Bool {
    didSet {
      if isSelected {
        backgroundColor = .mainBlue
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
      } else {
        backgroundColor = .subText
        layer.borderColor = UIColor.subText.cgColor
        layer.borderWidth = 0.5
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: .zero)
    setTitleColor(.white, for: .selected)
    layer.borderColor = UIColor.subText.cgColor
    layer.borderWidth = 0.5
    layer.cornerRadius = 3
    titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
  }

  convenience init(title: String) {
    self.init()

    setTitle(title, for: .normal)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

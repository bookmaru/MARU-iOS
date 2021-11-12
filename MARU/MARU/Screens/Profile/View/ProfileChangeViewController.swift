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
import simd

final class ProfileChangeViewController: UIViewController {
  private let exitButton = UIButton().then {
    $0.setImage(Image.group1011, for: .normal)
    $0.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
  }

  private let submitButton = UIButton().then {
    $0.setTitle("완료", for: .normal)
    $0.setTitleColor(.subText, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
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
    $0.addTarget(self, action: #selector(didTapChangeProfileButton), for: .touchUpInside)
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
    $0.borderStyle = .roundedRect
    $0.placeholder = "닉네임을 입력하세요."
  }

  private let nicknameCheckLabel = UILabel().then {
    $0.textColor = .subText
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.text = ""
    $0.isHidden = false
  }
  private let imageURL: String
  private let viewModel = ProfileChangeViewModel()
  private let nicknameViewModel = NicknameCheckViewModel()
  let picker = UIImagePickerController()
  let disposeBag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
    picker.delegate = self
    nicknameTextField.delegate = self
    render()
    profileBind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  init(imageURL: String) {
    self.imageURL = imageURL
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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

    changeProfileButton.snp.makeConstraints { make in
      make.top.equalTo(profileImageView.snp.bottom).offset(15)
      make.centerX.equalToSuperview()
      make.height.equalTo(14)
    }

    nicknameGuideLabel.snp.makeConstraints { make in
      make.leading.equalTo(exitButton.snp.leading)
      make.top.equalTo(changeProfileButton.snp.bottom).offset(49)
      make.height.equalTo(17)
    }

    asteriskLabel.snp.makeConstraints { make in
      make.leading.equalTo(nicknameGuideLabel.snp.trailing).offset(3)
      make.top.equalTo(changeProfileButton.snp.bottom).offset(45)
      make.size.equalTo(7)
    }

    nicknameTextField.snp.makeConstraints { make in
      make.leading.equalTo(nicknameGuideLabel.snp.leading)
      make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
      make.top.equalTo(nicknameGuideLabel.snp.bottom).offset(10)
      make.height.equalTo(37)
    }

    nicknameCheckLabel.snp.makeConstraints { make in
      make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
      make.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      make.height.equalTo(13)
    }
  }
}

extension ProfileChangeViewController {
  @objc func didTapExitButton() {
    self.dismiss(animated: true, completion: nil)
  }

  @objc func didTapChangeProfileButton() {
    let alert = UIAlertController()
    let library = UIAlertAction(title: "앨범에서 가져오기", style: .default) { _ in self.openLibrary() }
    let delete = UIAlertAction(title: "프로필 사진 삭제", style: .default) { _ in self.deletePhoto() }
    let cancel = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
    alert.addAction(library)
    alert.addAction(delete)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
  }

  private func deletePhoto() {
    profileImageView.image = Image.group1029
    submitButton.setTitleColor(.subText, for: .normal)
  }
  private func openLibrary() {
    picker.sourceType = .photoLibrary
    present(picker, animated: false, completion: nil)
  }

  private func bind() {
    nicknameTextField.rx.text
      .do { [weak self] text in
        guard let self = self,
              let text = text
        else { return }
        if text.count == 0 {
          self.nicknameCheckLabel.isHidden = true
        }
        if text.count > 13 {
          self.nicknameCheckLabel.isHidden = false
          self.nicknameCheckLabel.textColor = .negative
          self.nicknameCheckLabel.text = "13자리 이하의 닉네임만 설정가능합니다."
        }
        self.nicknameCheckLabel.isHidden = false
      }
      .filter { text -> Bool in
        guard let count = text?.count else { return false}
        if count != 0 && count < 13 { return true }
        return false
      }
      .flatMap { NetworkService.shared.auth.nickname(name: $0 ?? "").map { $0.status} }
      .subscribe(onNext: { [weak self] statusCode in
        guard let self = self else { return }
        if statusCode == 200 {
          self.nicknameCheckLabel.textColor = .subText
          self.nicknameCheckLabel.text = "사용 가능한 닉네임입니다."
        } else {
          self.nicknameCheckLabel.textColor = .negative
          self.nicknameCheckLabel.text = "이미 존재하는 이름입니다."
        }
      })
      .disposed(by: disposeBag)
  }

  private func profileBind() {
    profileImageView.image(url: imageURL)
    let didTapSubmitButton = submitButton.rx.tap
      .map { [weak self] _ -> (nickname: String, image: UIImage) in
        guard let self = self,
              let nickname = self.nicknameTextField.text,
              let image = self.profileImageView.image
        else { return (nickname: "", image: UIImage()) }
        return (nickname: nickname, image: image)
      }
    let input = ProfileChangeViewModel.Input(didTapSubmitButton: didTapSubmitButton)
    let output = viewModel.transform(input: input)

    output.isConnected
      .subscribe(onNext: {[weak self] _ in
        guard let self = self else { return }
        self.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
  }
}

extension ProfileChangeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      profileImageView.contentMode = .scaleAspectFit
      profileImageView.image = image
      submitButton.setTitleColor(.mainBlue, for: .normal)
    }
    dismiss(animated: true, completion: nil)
  }
}

extension ProfileChangeViewController: UITextFieldDelegate {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nickname = nicknameTextField.text
    if nickname?.count != 0 {
      bind()
      textField.resignFirstResponder()
    }
    return true
  }
}

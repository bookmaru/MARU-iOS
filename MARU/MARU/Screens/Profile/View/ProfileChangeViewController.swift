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
  private let viewModel = ProfileChangeViewModel()
  private let nicknameViewModel = NicknameCheckViewModel()
  let picker = UIImagePickerController()
  let disposeBag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
    picker.delegate = self
    nicknameTextField.delegate = self
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
    let library = UIAlertAction(title: "앨범에서 가져오기", style: .default) { (action) in self.openLibrary() }
    let cancel = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
    alert.addAction(library)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
  }

  func openLibrary() {
    picker.sourceType = .photoLibrary
    present(picker, animated: false, completion: nil)
  }

  func bind() {
    let changeNickname = PublishSubject<Void>()
    let input = NicknameCheckViewModel.Input(
      changeNickname: changeNickname,
      nickname: nicknameTextField.text ?? ""
    )
    let output = nicknameViewModel.transform(input: input)
    output.isSuccess
      .subscribe(onNext: { [weak self] isSuccess in
        guard let self = self else { return }
        if isSuccess == 200 {
          self.nicknameCheckLabel.text = "사용 가능한 닉네임입니다."
        }
        if isSuccess == 400 {
          self.nicknameCheckLabel.text = "이미 존재하는 닉네임입니다."
        }
      })
      .disposed(by: disposeBag)
  }
}

extension ProfileChangeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:Any]
  ) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      profileImageView.contentMode = .scaleAspectFit
      profileImageView.image = image
    }
    dismiss(animated: true, completion: nil)
  }
}

extension ProfileChangeViewController: UITextFieldDelegate {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // TODO: 닉네임 변경 서버 연결하기 200이면 성공, 400이면 중복
    var nickname = nicknameTextField.text
    if nickname?.count != 0 {
      bind()
      textField.resignFirstResponder()
    }
    return true
  }
}

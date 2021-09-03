//
//  MyLibraryHeaderView.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class MyLibraryHeaderView: UICollectionReusableView {
  static let registerId = "headerView"
  private let profileImageView = UIImageView().then {
    $0.image = Image.appIcon
    $0.layer.cornerRadius = 38
  }

  private let changeProfileButton = UIButton().then {
    $0.setImage(Image.group1015, for: .normal)
    $0.layer.cornerRadius = 20/2
  }

  private let usernameLabel = UILabel().then {
    $0.text = "닉네임"
    $0.font = .systemFont(ofSize: 16, weight: .bold)
  }

  private let gradeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .regular)
    $0.textColor = .gray
    let attributeString = NSMutableAttributedString(string: "방장 평점 4.5")
    let multipleAttribute: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12, weight: .heavy)
    ]
    attributeString.addAttributes(multipleAttribute, range: NSRange(location: 6, length: 3))
    $0.attributedText = attributeString
  }
  let changeSettingButton = UIButton().then {
    $0.setImage(Image.group962, for: .normal)
  }
  var disposeBag = DisposeBag()
  fileprivate var data: User? {
    didSet {
      usernameLabel.text = data?.user?.nickname
    }
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  private func render() {
    add(changeSettingButton) { button in
      button.snp.makeConstraints {
        $0.top.equalToSuperview()
        $0.trailing.equalToSuperview().offset(-10)
        $0.size.equalTo(40)
      }
    }
    add(profileImageView) { view in
      view.snp.makeConstraints {
        $0.size.equalTo(75)
        $0.centerX.equalToSuperview()
        $0.top.equalTo(self.changeSettingButton.snp.bottom).offset(0)
      }
    }
    add(changeProfileButton) { button in
      button.snp.makeConstraints {
        $0.size.equalTo(20)
        $0.trailing.bottom.equalTo(self.profileImageView).inset(-5)
      }
    }
    add(usernameLabel) { label in
      label.snp.makeConstraints {
        $0.top.equalTo(self.profileImageView.snp.bottom).offset(10)
        $0.centerX.equalToSuperview()
      }
    }
    add(gradeLabel) { label in
      label.snp.makeConstraints {
        $0.top.equalTo(self.usernameLabel.snp.bottom).offset(10)
        $0.centerX.equalToSuperview()
      }
    }
  }
}

extension Reactive where Base: MyLibraryHeaderView {
  var profileBinder: Binder<User> {
    return Binder(base) { base, data in
      base.data = data
    }
  }
}

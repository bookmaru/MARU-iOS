//
//  OnboardingLoginCollectionViewCell.swift
//  MARU
//
//  Created by 오준현 on 2021/06/05.
//

import UIKit

import RxCocoa
import RxSwift

final class OnboardingLoginCollectionViewCell: UICollectionViewCell {

  private let guideLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .red
    return imageView
  }()

  private let leftHairlineView: UIView = {
    let view = UIView()
    view.backgroundColor = .veryLightPink
    return view
  }()

  private let loginGuideLabel: UILabel = {
    let label = UILabel()
    label.text = "간편 로그인"
    label.font = .systemFont(ofSize: 13, weight: .semibold)
    label.textColor = .veryLightPink
    return label
  }()

  private let rightHairlineView: UIView = {
    let view = UIView()
    view.backgroundColor = .veryLightPink
    return view
  }()

  fileprivate let kakaoLoginButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .yellow
    return button
  }()

  fileprivate let appleLoginButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .black
    return button
  }()

  var disposeBag = DisposeBag()

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
}

extension OnboardingLoginCollectionViewCell {
  func bind(guide: String) {
    guideLabel.text = guide
  }

  private func render() {
    contentView.add(guideLabel) { label in
      label.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.bottom.equalTo(self.snp.centerY).offset(-195.5)
      }
    }
    contentView.add(imageView) { view in
      view.snp.makeConstraints {
        $0.top.equalTo(self.guideLabel.snp.bottom).offset(26)
        $0.centerX.equalToSuperview()
        $0.size.equalTo(248)
      }
    }
    contentView.add(loginGuideLabel) { label in
      label.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalTo(self.imageView.snp.bottom).offset(21)
        $0.width.equalTo(60)
      }
    }
    contentView.add(leftHairlineView) { view in
      view.snp.makeConstraints {
        $0.trailing.equalTo(self.loginGuideLabel.snp.leading).offset(-10)
        $0.centerY.equalTo(self.loginGuideLabel.snp.centerY)
        $0.leading.equalTo(self.imageView)
        $0.height.equalTo(0.5)
      }
    }
    contentView.add(rightHairlineView) { view in
      view.snp.makeConstraints {
        $0.leading.equalTo(self.loginGuideLabel.snp.trailing).offset(10)
        $0.centerY.equalTo(self.loginGuideLabel.snp.centerY)
        $0.trailing.equalTo(self.imageView)
        $0.height.equalTo(0.5)
      }
    }
    contentView.add(kakaoLoginButton) { button in
      button.snp.makeConstraints {
        $0.leading.trailing.equalTo(self.imageView)
        $0.top.equalTo(self.loginGuideLabel.snp.bottom).offset(14)
        $0.height.equalTo(39)
      }
    }
    contentView.add(appleLoginButton) { button in
      button.snp.makeConstraints {
        $0.leading.trailing.equalTo(self.imageView)
        $0.top.equalTo(self.kakaoLoginButton.snp.bottom).offset(9)
        $0.height.equalTo(39)
      }
    }
  }
}

extension Reactive where Base: OnboardingLoginCollectionViewCell {
  var didTapAppleLoginButton: Observable<Void> {
    base
      .appleLoginButton.rx.tap
      .asObservable()
  }

  var didTapKakaoLoginButton: Observable<Void> {
    base
      .kakaoLoginButton.rx.tap
      .asObservable()
  }
}

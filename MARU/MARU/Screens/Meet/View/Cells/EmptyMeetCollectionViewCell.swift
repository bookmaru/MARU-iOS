//
//  EmptyMeetCollectionViewCell.swift
//  MARU
//
//  Created by 오준현 on 2021/04/17.
//

import UIKit

import Then

final class EmptyMeetCollectionViewCell: UICollectionViewCell {

  private let emptyView = UIView().then {
    $0.backgroundColor = .veryLightPink
  }
  private let emptyImageView = UIImageView().then {
    $0.image = Image.bookIconGray
  }
  private let bottomContainerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
    $0.applyShadow(color: .black, alpha: 0.16, shadowX: 0, shadowY: 0, blur: 10)
  }
  private let addButton = UIButton().then {
    $0.setImage(Image.plusIcon, for: .normal)
    $0.setTitle("   모임 열기", for: .normal)
    $0.setTitleColor(.cornflowerBlue, for: .normal)
    $0.titleLabel?.font = .boldSystemFont(ofSize: 13)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    layoutSuperView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension EmptyMeetCollectionViewCell {
  private func layoutSuperView() {
    adds([
      emptyView,
      emptyImageView,
      bottomContainerView,
      addButton
    ])
    emptyView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview()
      $0.width.equalTo(frame.width-66)
      $0.height.equalTo(312 / 421 * frame.height)
    }
    bottomContainerView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(191 / 421 * frame.height)
    }
    emptyImageView.snp.makeConstraints {
      $0.centerX.equalTo(emptyView)
      $0.top.equalTo(emptyView).offset(61 / 421 * frame.height)
      $0.width.equalTo(76)
      $0.height.equalTo(114)
    }
    addButton.snp.makeConstraints {
      $0.centerY.equalTo(bottomContainerView)
      $0.leading.trailing.equalTo(bottomContainerView)
      $0.height.equalTo(50)
    }
  }
}

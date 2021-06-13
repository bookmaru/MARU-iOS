//
//  OnboardingLoginCollectionViewCell.swift
//  MARU
//
//  Created by 오준현 on 2021/06/05.
//

import UIKit

final class OnboardingLoginCollectionViewCell: UICollectionViewCell {

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.text = "123123213"
    return label
  }()

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension OnboardingLoginCollectionViewCell {
  private func render() {
    contentView.add(titleLabel) { label in
      label.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.bottom.equalTo(self.snp.centerY).offset(-195.5)
      }
    }
  }
}

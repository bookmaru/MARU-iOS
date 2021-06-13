//
//  OnboardingCollectionViewCell.swift
//  MARU
//
//  Created by 오준현 on 2021/06/05.
//

import UIKit

import RxCocoa
import RxSwift

final class OnboardingCollectionViewCell: UICollectionViewCell {

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

  private let subGuideLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 13, weight: .regular)
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension OnboardingCollectionViewCell {

  func bind(guide: String, subGuide: String) {
    guideLabel.text = guide
    subGuideLabel.text = subGuide
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
        $0.top.equalTo(self.guideLabel.snp.bottom).offset(17)
        $0.leading.trailing.equalToSuperview()
        $0.height.equalTo(356)
      }
    }
    contentView.add(subGuideLabel) { label in
      label.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalTo(self.imageView.snp.bottom).offset(24)
      }
    }
  }
}

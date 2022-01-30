//
//  EmptyView.swift
//  MARU
//
//  Created by 오준현 on 2021/10/04.
//

import UIKit

import SnapKit

final class EmptyView: UIView {

  private let imageView = UIImageView().then {
    $0.tintColor = .subText
  }
  private let label = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.numberOfLines = 0
    $0.textColor = .subText
    $0.textAlignment = .center
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  convenience init(image: UIImage, content: String) {
    self.init(frame: .zero)
    imageView.image = image
    label.text = content
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {
    add(imageView)
    add(label)

    label.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    imageView.snp.makeConstraints {
      $0.bottom.equalTo(label.snp.top).offset(-10)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(24)
    }
  }
}

//
//  SettingCollectionViewCell.swift
//  MARU
//
//  Created by 오준현 on 2021/08/06.
//

import UIKit

final class SettingCollectionViewCell: UICollectionViewCell {

  private let label = UILabel().then {
    $0.font = .systemFont(ofSize: 15, weight: .regular)
  }
  private let sepratorView = UIView().then {
    $0.backgroundColor = .brownishGrey
  }
  private let arrowImageView = UIImageView(image: Image.rightArrow)
  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {
    contentView.add(label)
    contentView.add(sepratorView)
    contentView.add(arrowImageView)
    label.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
    sepratorView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.top.equalToSuperview()
      $0.height.equalTo(1)
    }
    arrowImageView.snp.makeConstraints {
      $0.size.equalTo(20)
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-20)
    }
  }

  func separatorViewRow(row: Int) {
    sepratorView.isHidden = row == 0
  }

  func titleLabel(title: String) {
    label.text = title
  }
}

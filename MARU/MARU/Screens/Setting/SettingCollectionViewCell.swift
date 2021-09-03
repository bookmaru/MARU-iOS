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
  private let sepraterView = UIView().then {
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
    contentView.add(sepraterView)
    contentView.add(arrowImageView)
    // 연결하면서 Cell파일 계속 터져서 확인해보니 add 빠뜨린 문제였음
    // adds로 바꿔주세욥
    // sepraterView 오타 -> separatorView
    label.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
    sepraterView.snp.makeConstraints {
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
    sepraterView.isHidden = row == 0
  }

  func titleLabel(title: String) {
    label.text = title
  }
}

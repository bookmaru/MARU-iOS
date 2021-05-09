//
//  MyChatCell.swift
//  MARU
//
//  Created by 오준현 on 2021/05/05.
//

import UIKit

final class MyChatCollectionViewCell: UICollectionViewCell {

  private let nameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.numberOfLines = 0
  }

  private let chatLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.numberOfLines = 0
  }

  private let chatBubbleView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 16
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
  }
}

//
//  NewMeetingCell.swift
//  MARU
//
//  Created by psychehose on 2021/05/05.
//

import UIKit

final class NewMeetingCell: UICollectionViewCell {
  // MARK: - UIComponent
  static let identifier = "NewMeetingCell"

  let shadowView = UIView().then {
      $0.backgroundColor = .white
  }

  let bookImageView = UIImageView().then {
      $0.backgroundColor = .red
  }

  let bookTitleLabel = UILabel().then {
      $0.text = "test1"
      $0.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.semibold)
      $0.textAlignment = .left
      $0.sizeToFit()
  }

  let bookAuthorLabel = UILabel().then {
    $0.text = "test2"
    $0.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.light)
    $0.textAlignment = .left

  }

  let bookMeetingChiefLabel = UILabel().then {
    $0.text = "test3"
    $0.textColor = .cornflowerBlue
    $0.textAlignment = .right
    $0.sizeToFit()
  }

  let explainBox = UILabel().then {
    $0.backgroundColor = .white
  }

  let bookMeetingExplainementLabel = UILabel().then {
    $0.text = "test5"
    $0.textAlignment = .center
    $0.textColor = UIColor.black
    $0.numberOfLines = 3
  }

  let leftQuotataionMarkImage = UIImageView().then {
    $0.image = UIImage(named: "qmarkLeft")
  }

  let rightQuotataionMarkImage = UIImageView().then {
    $0.image = UIImage(named: "qmarkRight")
  }

  // MARK: - Properties

  // MARK: - Override Init

  override init(frame: CGRect) {
      super.init(frame: frame)
    applyLayout()
    applyShadow()
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  private func applyLayout() {

    add(shadowView)
    shadowView.adds([bookImageView,
                     bookTitleLabel,
                     bookAuthorLabel,
                     bookMeetingChiefLabel,
                     explainBox])

    explainBox.adds([bookMeetingExplainementLabel,
                     leftQuotataionMarkImage,
                     rightQuotataionMarkImage])

    // MARK: - AutoLayOut Set

    shadowView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top).inset(1)
      make.bottom.equalTo(contentView.snp.bottom).inset(1)
      make.leading.equalTo(contentView.snp.leading).inset(1)
      make.trailing.equalTo(contentView.snp.trailing).inset(1)
    }

    bookImageView.snp.makeConstraints { ( make ) in
      make.top.equalTo(shadowView.snp.top).inset(0)
      make.leading.equalTo(shadowView.snp.leading).inset(0)
      make.bottom.equalTo(shadowView.snp.bottom).inset(0)
      make.width.equalTo(80)
    }

    bookTitleLabel.snp.makeConstraints { ( make ) in
      make.top.equalTo(shadowView.snp.top).inset(10)
      make.leading.equalTo(bookImageView.snp.trailing).inset(-10)
      make.width.lessThanOrEqualTo(shadowView.snp.width)
      make.height.equalTo(13)
    }

    bookAuthorLabel.snp.makeConstraints { ( make ) in
      make.top.equalTo(shadowView.snp.top).inset(12)
      make.leading.equalTo(bookTitleLabel.snp.trailing).inset(-3)
      make.height.equalTo(12)
    }

    explainBox.snp.makeConstraints { ( make ) in
      make.top.equalTo(bookTitleLabel.snp.bottom).inset(-9)
      make.leading.equalTo(bookImageView.snp.trailing).inset(-10)
      make.trailing.equalTo(shadowView.snp.trailing).inset(12)
      make.height.equalTo(49)
    }

    leftQuotataionMarkImage.snp.makeConstraints { ( make ) in
      make.top.equalTo(explainBox.snp.top).inset(0)
      make.leading.equalTo(explainBox.snp.leading).inset(0)
      make.width.equalTo(8)
      make.height.equalTo(7)
    }
    rightQuotataionMarkImage.snp.makeConstraints { ( make ) in
      make.bottom.equalTo(explainBox.snp.bottom).inset(0)
      make.trailing.equalTo(explainBox.snp.trailing).inset(0)
      make.width.equalTo(8)
      make.height.equalTo(7)
    }
    bookMeetingExplainementLabel.snp.makeConstraints { ( make ) in
      make.top.equalTo(explainBox.snp.top).inset(0)
      make.bottom.equalTo(explainBox.snp.bottom).inset(0)
      make.leading.equalTo(leftQuotataionMarkImage.snp.trailing).inset(-5)
      make.trailing.equalTo(rightQuotataionMarkImage.snp.leading).inset(0)
    }
    bookMeetingChiefLabel.snp.makeConstraints { ( make ) in
      make.top.equalTo(explainBox.snp.bottom).inset(-8)
      make.trailing.equalTo(shadowView.snp.trailing).inset(12)
      make.height.equalTo(11)
      make.width.equalTo(200)
    }
  }

  private func applyShadow() {
    shadowView.layer.masksToBounds = true
    shadowView.layer.cornerRadius = 8
    shadowView.layer.borderWidth = 0.5
    shadowView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
    shadowView.layer.shadowColor = UIColor.black.cgColor
    shadowView.layer.shadowOffset = .zero
    shadowView.layer.shadowRadius = 1.5
    shadowView.layer.shadowOpacity = 0.28
    shadowView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
  }
}

//
//  NewMeetingCell.swift
//  MARU
//
//  Created by psychehose on 2021/05/05.
//

import UIKit

final class NewMeetingCell: UICollectionViewCell {
  // MARK: - UIComponent

  private let shadowView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 5
  }

  private let bookImageView = UIImageView().then {
    $0.backgroundColor = .clear
    $0.image = Image.testImage
  }

  private let bookTitleLabel = UILabel().then {
    $0.text = "test1"
    $0.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.semibold)
    $0.textAlignment = .left
//    $0.sizeToFit()
  }

  private let bookAuthorLabel = UILabel().then {
    $0.text = "test2"
    $0.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.light)
    $0.textAlignment = .left
    $0.adjustsFontSizeToFitWidth = true
    $0.sizeToFit()

  }

  private let bookMeetingChiefLabel = UILabel().then {
    $0.text = "test3"
    $0.textColor = .mainBlue
    $0.textAlignment = .right
    $0.font = .systemFont(ofSize: 10, weight: .bold)
  }

  private let explainBox = UILabel().then {
    $0.backgroundColor = .white
  }

  private let bookMeetingExplainementLabel = UILabel().then {
    $0.text = "test5"
    $0.textAlignment = .center
    $0.textColor = UIColor.black
    $0.numberOfLines = 3
  }

  private let leftQuotataionMarkImageView = UIImageView().then {
    $0.image = Image.blueQuotationleft
  }

  private let rightQuotataionMarkImageView = UIImageView().then {
    $0.image = Image.blueQuotationRight
  }
  private let remainPeriodLabel = UILabel().then {
    $0.text = "test6"
    $0.textAlignment = .left
    $0.textColor = UIColor.mainBlue
    $0.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
    $0.adjustsFontSizeToFitWidth = true
    $0.sizeToFit()
  }
  // MARK: - RX로 교체할 수 있지 않을까?

  var mainModel: MainModel? {
    didSet {
//      bookImageView.image = viewMainModel?.book.bookImage
      bookTitleLabel.text = mainModel?.book.bookTitle
      bookAuthorLabel.text = mainModel?.book.bookAuthor
      bookMeetingChiefLabel.text = mainModel?.book.roomChief
      bookMeetingExplainementLabel.text = mainModel?.book.bookComment
    }
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
    shadowView.adds([
      bookImageView,
      bookTitleLabel,
      remainPeriodLabel,
      bookAuthorLabel,
      bookMeetingChiefLabel,
      explainBox
    ])

    explainBox.adds([
      bookMeetingExplainementLabel,
      leftQuotataionMarkImageView,
      rightQuotataionMarkImageView
    ])

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
      make.width.equalTo(96)
    }

    bookTitleLabel.snp.makeConstraints { ( make ) in
      make.top.equalTo(shadowView.snp.top).inset(10)
      make.leading.equalTo(bookImageView.snp.trailing).inset(-10)
      make.width.lessThanOrEqualTo(shadowView.snp.width)
      make.height.equalTo(13)
    }
    remainPeriodLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(bookTitleLabel.snp.centerY)
      make.trailing.equalTo(shadowView.snp.trailing).inset(11)
    }

    bookAuthorLabel.snp.makeConstraints { ( make ) in
      make.top.equalTo(bookTitleLabel.snp.bottom).inset(-3)
      make.leading.equalTo(bookImageView.snp.trailing).inset(-10)
      make.height.equalTo(12)
    }

    explainBox.snp.makeConstraints { ( make ) in
      make.top.equalTo(bookAuthorLabel.snp.bottom).inset(-12)
      make.leading.equalTo(bookImageView.snp.trailing).inset(-10)
      make.trailing.equalTo(shadowView.snp.trailing).inset(12)
      make.height.equalTo(61)
    }

    leftQuotataionMarkImageView.snp.makeConstraints { ( make ) in
      make.top.equalTo(explainBox.snp.top).inset(0)
      make.leading.equalTo(explainBox.snp.leading).inset(0)
      make.width.equalTo(8)
      make.height.equalTo(7)
    }
    rightQuotataionMarkImageView.snp.makeConstraints { ( make ) in
      make.bottom.equalTo(explainBox.snp.bottom).inset(0)
      make.trailing.equalTo(explainBox.snp.trailing).inset(0)
      make.width.equalTo(8)
      make.height.equalTo(7)
    }
    bookMeetingExplainementLabel.snp.makeConstraints { ( make ) in
      make.top.equalTo(explainBox.snp.top).inset(0)
      make.bottom.equalTo(explainBox.snp.bottom).inset(0)
      make.leading.equalTo(leftQuotataionMarkImageView.snp.trailing).inset(-5)
      make.trailing.equalTo(rightQuotataionMarkImageView.snp.leading).inset(0)
    }
    bookMeetingChiefLabel.snp.makeConstraints { ( make ) in
      make.top.equalTo(explainBox.snp.bottom).inset(-8)
      make.trailing.equalTo(shadowView.snp.trailing).inset(12)
      make.height.equalTo(12)
      make.width.equalTo(200)
    }
  }

  private func applyShadow() {
    shadowView.applyShadow(color: .black,
                alpha: 0.28,
                shadowX: 0,
                shadowY: 0,
                blur: 15/2)
  }
}

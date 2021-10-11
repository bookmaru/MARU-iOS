//
//  BookListCell.swift
//  MARU
//
//  Created by 김호세 on 2021/09/27.
//

import UIKit

final class BookListCell: UICollectionViewCell {

  private let shadowView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 5
  }

  private let bookImageView = UIImageView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 5
  }

  private let bookTitleLabel = UILabel().then {
    $0.text = "test1"
    $0.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
    $0.textAlignment = .left
  }

  private let bookAuthorLabel = UILabel().then {
    $0.text = "test2"
    $0.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.light)
    $0.textAlignment = .left
    $0.textColor = .subText
  }
  private var bookImage: UIImage? {
    didSet {
      bookImageView.image = bookImage
    }
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    applyLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    bookAuthorLabel.text = nil
    bookTitleLabel.text = nil
    bookImageView.image = nil
  }

  func bind(_ bookModel: BookModel) {
    bookAuthorLabel.text = bookModel.author
    bookTitleLabel.text = bookModel.title
    bookImageView.image(url: bookModel.imageURL, defaultImage: Image.defalutImage ?? UIImage())
  }
  private func applyLayout() {
    add(shadowView)
    shadowView.adds([
      bookImageView,
      bookTitleLabel,
      bookAuthorLabel
    ])

    // MARK: - AutoLayOut Set

    shadowView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top).inset(1)
      make.bottom.equalTo(contentView.snp.bottom).inset(1)
      make.leading.equalTo(contentView.snp.leading).inset(1)
      make.trailing.equalTo(contentView.snp.trailing).inset(1)
    }
    bookImageView.snp.makeConstraints { ( make ) in
      make.top.equalTo(shadowView.snp.top)
      make.leading.equalTo(shadowView.snp.leading)
      make.bottom.equalTo(shadowView.snp.bottom)
      make.width.equalTo(96)
    }
    bookTitleLabel.snp.makeConstraints { ( make ) in
      make.top.equalTo(shadowView.snp.top).inset(10)
      make.leading.equalTo(bookImageView.snp.trailing).inset(-10)
      make.width.equalToSuperview().multipliedBy(0.403)
      make.height.equalTo(13)
    }
    bookAuthorLabel.snp.makeConstraints { ( make ) in
      make.top.equalTo(bookTitleLabel.snp.bottom).inset(-3)
      make.leading.equalTo(bookImageView.snp.trailing).inset(-10)
      make.height.equalTo(12)
    }
  }

  private func applyShadow() {
    shadowView.applyShadow(
      color: .black,
      alpha: 0.28,
      shadowX: 0,
      shadowY: 0,
      blur: 15/2
    )
  }
}

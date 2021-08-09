//
//  PopularMeetingCell.swift
//  MARU
//
//  Created by psychehose on 2021/05/05.
//

import UIKit

final class BookCell: UICollectionViewCell {
  private let bookImageView = UIImageView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 5
  }
  private let bookTitleLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    $0.text = "gihi"
  }
  private let bookAuthorLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 10, weight: .medium)
    $0.text = "이이이리리리"
  }
  private var bookImage: UIImage! {
    didSet {
      bookImageView.image = bookImage
    }
  }
  // MARK: - Override Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    applyLayout()
  }
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    bookTitleLabel.text = ""
    bookAuthorLabel.text = ""
    bookImage = Image.testImage
  }

  func bind(_ bookModel: BookModel) {
    bookTitleLabel.text = bookModel.title
    bookAuthorLabel.text = bookModel.author
    let url = URL(string: bookModel.imageUrl)

    do {
      if let url = url {
        let data = try Data(contentsOf: url)
        bookImage = UIImage(data: data)
      }
    } catch _ {
      bookImage = Image.testImage
    }
  }
  private func applyLayout() {
    add(bookImageView)
    add(bookTitleLabel)
    add(bookAuthorLabel)

    bookImageView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top).inset(0)
      make.leading.equalTo(contentView.snp.leading).inset(0)
      make.trailing.equalTo(contentView.snp.trailing).inset(0)
      make.height.equalTo(130)
    }

    bookTitleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(bookImageView.snp.bottom).inset(-11)
      make.leading.equalTo(contentView.snp.leading).inset(0)
      make.width.equalTo(contentView.snp.width)
      make.height.equalTo(13)
    }

    bookAuthorLabel.snp.makeConstraints { (make) in
      make.top.equalTo(bookTitleLabel.snp.bottom).inset(-5)
      make.leading.equalTo(contentView.snp.leading).inset(0)
      make.width.equalTo(contentView.snp.width)
      make.height.equalTo(10)
    }
  }
  func name() -> String? {
    return bookTitleLabel.text
  }
}

//
//  PopularMeetingCell.swift
//  MARU
//
//  Created by psychehose on 2021/05/05.
//

import UIKit

class PopularMeetingCell: UICollectionViewCell {

  let bookImageView = UIImageView().then {
      $0.backgroundColor = .yellow
  }
  var bookTitleLabel = UILabel().then {
      $0.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
      $0.text = "gihi"
  }
  let bookAuthorLabel = UILabel().then {
      $0.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium)
      $0.text = "이이이리리리"
  }

  // MARK: - Override Init

  override init(frame: CGRect) {

      super.init(frame: frame)
      self.addSubview(bookImageView)
      self.addSubview(bookTitleLabel)
      self.addSubview(bookAuthorLabel)

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

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
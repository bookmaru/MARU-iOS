//
//  MyDiaryCell.swift
//  MARU
//
//  Created by 오준현 on 2021/09/19.
//

import UIKit

final class MyDiaryCell: UICollectionViewCell {

  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let authorLabel = UILabel()
  private let editButton = UIButton()
  private let contentContainerView = UIView()
  private let leftQuotationImageView = UIImageView()
  private let rightQuotationImageView = UIImageView()
  private let contentLabel = UILabel()
  private let ownerLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {
    contentView.add(imageView)
    contentView.add(titleLabel)
    contentView.add(authorLabel)
    contentView.add(editButton)
    contentView.add(contentContainerView)
    contentContainerView.add(contentLabel)
    contentContainerView.add(leftQuotationImageView)
    contentContainerView.add(rightQuotationImageView)
    contentView.add(ownerLabel)
    imageView.snp.makeConstraints {
      $0.leading.top.bottom.equalToSuperview()
      $0.width.equalTo(96)
    }
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(imageView.snp.trailing)
      $0.top.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-65)
    }
    authorLabel.snp.makeConstraints {
      $0.leading.equalTo(titleLabel)
      $0.top.equalTo(titleLabel.snp.bottom).offset(3)
    }
    editButton.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(7)
      $0.size.equalTo(24)
    }
    contentContainerView.snp.makeConstraints {
      let inset = UIEdgeInsets(top: 50, left: 109, bottom: 31, right: 13)
      $0.edges.equalToSuperview().inset(inset)
    }
    contentLabel.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    leftQuotationImageView.snp.makeConstraints {
      $0.leading.top.equalToSuperview()
      $0.width.equalTo(9.3)
      $0.height.equalTo(8.1)
    }
    rightQuotationImageView.snp.makeConstraints {
      $0.trailing.bottom.equalToSuperview()
      $0.width.equalTo(9.3)
      $0.height.equalTo(8.1)
    }
    ownerLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-10)
      $0.bottom.trailing.equalToSuperview().offset(-13)
    }
  }
}

//
//  MeetCollectionViewCell.swift
//  MARU
//
//  Created by 오준현 on 2021/04/09.
//

import UIKit

import Then

final class MeetCollectionViewCell: UICollectionViewCell {

  private let posterImageView = UIImageView().then {
    $0.image = UIImage()
  }
  private let gradientImageView = UIImageView().then {
    $0.image = UIImage(named: "gradientImage")
  }
  private let bookTitleLabel = UILabel().then {
    $0.text = "제목"
    $0.font = .boldSystemFont(ofSize: 16)
    $0.textColor = .white
  }
  private let authorNameLabel = UILabel().then {
    $0.text = "이름"
    $0.font = .systemFont(ofSize: 11, weight: .medium)
    $0.textColor = .white
  }
  private let isMyRoomImageView = UIImageView().then {
    $0.image = UIImage()
  }
  private let bottomContainerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
    $0.applyShadow(color: .black, alpha: 0.16, shadowX: 0, shadowY: 0, blur: 10)
  }
  private let leftQuoteImageView = UIImageView()
  private let contentLabel = UILabel()
  private let rightQuoteImageView = UIImageView()
  private let splitView = UIView()
  private let nameLabel = UILabel()
  private let timeLabel = UILabel()
  private let chatLabel = UILabel()
  private let view = UIView()
  private let label = UILabel()
  override init(frame: CGRect) {
    super.init(frame: frame)

    layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension MeetCollectionViewCell {

  private func layout() {
    adds([
      posterImageView,
      gradientImageView,
      bottomContainerView
    ])
    gradientImageView.adds([
      bookTitleLabel,
      authorNameLabel
    ])
    bottomContainerView.adds([
      leftQuoteImageView,
      contentLabel,
      rightQuoteImageView
    ])
    posterImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview()
      $0.width.equalTo(frame.width-66)
      $0.height.equalTo(312 / 421 * frame.height)
    }
    gradientImageView.snp.makeConstraints {
      $0.edges.equalTo(posterImageView)
    }
    bottomContainerView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(191 / 421 * frame.height)
    }
    bookTitleLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(18)
      $0.trailing.equalToSuperview().offset(10)
    }
    authorNameLabel.snp.makeConstraints {
      $0.top.equalTo(bookTitleLabel.snp.bottom).offset(5.8)
      $0.leading.equalToSuperview().offset(18)
    }
  }
}

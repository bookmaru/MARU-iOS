//
//  MeetCollectionViewCell.swift
//  MARU
//
//  Created by 오준현 on 2021/04/09.
//

import UIKit

import Then
import RxCocoa
import RxSwift

final class MeetCollectionViewCell: UICollectionViewCell {

  private let posterImageView = UIImageView().then {
    $0.image = UIImage()
  }
  private let gradientImageView = UIImageView().then {
    $0.image = Image.gradientImage
  }
  private let bookTitleLabel = UILabel().then {
    $0.font = .boldSystemFont(ofSize: 15)
    $0.textColor = .white
  }
  private let authorNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 11, weight: .medium)
    $0.textColor = .white
  }
  private let bookMarkImageView = UIImageView().then {
    $0.image = Image.bookmark
  }
  private let leftTimeLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .boldSystemFont(ofSize: 15)
  }
  private let bottomContainerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
    $0.applyShadow(color: .black, alpha: 0.16, shadowX: 0, shadowY: 0, blur: 10)
  }
  private let leftQuoteImageView = UIImageView().then {
    $0.image = Image.quotationMarkLeft
  }
  private let contentLabel = VerticalAlignLabel().then {
    $0.font = RIDIBatangFont.medium.of(size: 12)
    $0.textAlignment = .center
    $0.numberOfLines = 3
  }
  private let rightQuoteImageView = UIImageView().then {
    $0.image = Image.quotationMarkRight
  }
  private let splitView = UIView().then {
    $0.backgroundColor = UIColor.brownishGrey.withAlphaComponent(0.11)
  }
  private let nameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .medium)
  }
  private let timeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 10, weight: .medium)
    $0.textColor = .brownGreyTwo
  }
  private let chatLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = UIColor.black.withAlphaComponent(0.4)
  }
  private let chatCountContainerView = UIView().then {
    $0.backgroundColor = .mainBlue
    $0.layer.cornerRadius = 8
    $0.isHidden = true
  }
  private let chatCountLabel = UILabel().then {
    $0.font = .boldSystemFont(ofSize: 10)
    $0.textColor = .white
  }
  fileprivate var data: GeneratedGroup? {
    didSet {
      guard let data = data else { return }
      bookMarkImageView.isHidden = !(data.isLeader)
      posterImageView.image(url: data.image, defaultImage: UIImage())
      bookTitleLabel.text = data.title
      authorNameLabel.text = data.author
      nameLabel.text = data.chatUserName
      contentLabel.text = data.description
      chatLabel.text = data.message
      timeLabel.text = data.chatTime.chatTime
      leftTimeLabel.attributedText = setRemainDate(remainDay: data.remainingDay)
    }
  }
  override init(frame: CGRect) {
    super.init(frame: frame)

    layoutSuperView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension MeetCollectionViewCell {
  private func setRemainDate(remainDay: Int) -> NSMutableAttributedString {
    let text = "토론이 \(remainDay)일 남았습니다."
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(
      .foregroundColor, value: UIColor.mainBlue, range: (text as NSString).range(of: remainDay.string)
    )
    return attributedString
  }
}

// MARK: - Layout
extension MeetCollectionViewCell {
  private func layoutSuperView() {
    contentView.adds([
      posterImageView,
      gradientImageView,
      bottomContainerView
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
    layoutGradientView()
    layoutBottomContentView()
  }

  private func layoutGradientView() {
    gradientImageView.adds([
      bookTitleLabel,
      authorNameLabel,
      bookMarkImageView,
      leftTimeLabel
    ])
    bookTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(18 / 421 * frame.height)
      $0.leading.equalToSuperview().offset(18 / 375 * frame.width)
      $0.trailing.equalToSuperview().offset(-10 / 375 * frame.width)
    }
    authorNameLabel.snp.makeConstraints {
      $0.top.equalTo(bookTitleLabel.snp.bottom).offset(5.8 / 421 * frame.height)
      $0.leading.equalToSuperview().offset(18 / 375 * frame.width)
    }
    bookMarkImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-11 / 375 * frame.width)
      $0.height.width.equalTo(27)
    }
    leftTimeLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(18 / 375 * frame.width)
      $0.bottom.equalTo(bottomContainerView.snp.top).offset(-18 / 421 * frame.height)
    }
  }

  private func layoutBottomContentView() {
    bottomContainerView.adds([
      leftQuoteImageView,
      contentLabel,
      rightQuoteImageView,
      splitView,
      nameLabel,
      timeLabel,
      chatLabel,
      chatCountContainerView
    ])
    contentLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(38 / 375 * frame.width)
      $0.trailing.equalToSuperview().offset(-38 / 375 * frame.width)
      $0.centerY.equalTo(bottomContainerView.snp.top).offset(57 / 421 * frame.height)
    }
    leftQuoteImageView.snp.makeConstraints {
      $0.trailing.equalTo(contentLabel.snp.leading).offset(-12 / 375 * frame.width)
      $0.height.width.equalTo(7)
      $0.bottom.equalTo(contentLabel.snp.top)
    }
    rightQuoteImageView.snp.makeConstraints {
      $0.leading.equalTo(contentLabel.snp.trailing).offset(12 / 375 * frame.width)
      $0.height.width.equalTo(7)
      $0.top.equalTo(contentLabel.snp.bottom)
    }
    splitView.snp.makeConstraints {
      $0.centerY.equalTo(bottomContainerView.snp.top).offset(113 / 421 * frame.height)
      $0.height.equalTo(1)
      $0.leading.equalToSuperview().offset(22 / 375 * frame.width)
      $0.trailing.equalToSuperview().offset(-22 / 375 * frame.width)
    }
    nameLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(22 / 375 * frame.width)
      $0.top.equalTo(splitView.snp.bottom).offset(18 / 421 * frame.height)
    }
    timeLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-18 / 375 * frame.width)
      $0.centerY.equalTo(nameLabel)
    }
    chatLabel.snp.makeConstraints {
      $0.leading.equalTo(nameLabel)
      $0.top.equalTo(nameLabel.snp.bottom).offset(8 / 421 * frame.height)
    }
    chatCountContainerView.snp.makeConstraints {
      $0.trailing.equalTo(timeLabel)
      $0.centerY.equalTo(chatLabel)
      $0.width.height.equalTo(16)
    }
    layoutChatCount()
  }
  private func layoutChatCount() {
    chatCountContainerView.add(chatCountLabel) { chatCountLabel in
      chatCountLabel.snp.makeConstraints {
        $0.centerY.centerX.equalToSuperview()
      }
    }
    chatLabel.snp.remakeConstraints {
      $0.leading.equalTo(nameLabel)
      $0.top.equalTo(nameLabel.snp.bottom).offset(8 / 421 * frame.height)
      $0.trailing.equalTo(chatCountContainerView.snp.leading).offset(-10)
    }
  }
}

extension Reactive where Base: MeetCollectionViewCell {
  var dataBinder: Binder<GeneratedGroup> {
    return Binder(base) { base, data in
      base.data = data
    }
  }
}

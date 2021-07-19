//
//  LibraryDiaryCell.swift
//  MARU
//
//  Created by 이윤진 on 2021/07/19.
//

import UIKit

final class LibraryDiaryCell: UITableViewCell {
  private let diaryCellView = UIView().then {
    $0.backgroundColor = .white
    $0.applyShadow(color: .black, alpha: 0.15, shadowX: 0, shadowY: 2, blur: 5/2)
    $0.layer.cornerRadius = 5
  }
  private let bookImageView = UIImageView().then {
    $0.image = Image.union
  }
  /* 추후 그라데이션 값 추가할 것임
   //  private let shadowView = UIView().then {
   //    $0.backgroundColor = .clear
   //  }
   */
  private let bookTitleLabel = UILabel().then {
    $0.text = "보건교사안은영"
    $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    $0.textColor = .white
    $0.textAlignment = .left
  }
  private let bookAuthorLabel = UILabel().then {
    $0.text = "정세랑"
    $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
    $0.textColor = .white
    $0.textAlignment = .left
  }
  private let diaryTitleLabel = UILabel().then {
    $0.text = "보건보건교사다나를아느냐"
    $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    $0.textAlignment = .left
  }
  private let diaryDateLabel = UILabel().then {
    $0.text = "YYYY.MM.DD"
    $0.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
    $0.textColor = .subText
    $0.textAlignment = .left
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    setLayout()
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  func setLayout() {
    contentView.add(diaryCellView)
    diaryCellView.adds([
      bookImageView,
      diaryTitleLabel,
      diaryDateLabel
    ])
    /*  gradient 이미지 값 추가하고 이 부분 수정 들어갑니다.
     //    bookImageView.add(shadowView)
     //    shadowView.adds([
     //      bookTitleLabel,
     //      bookAuthorLabel
     //    ])
     */
    bookImageView.adds([
      bookTitleLabel,
      bookAuthorLabel
    ])
    // make랑 (make) 차이가 있을까?
    diaryCellView.snp.makeConstraints { make in
      make.top.equalTo(contentView.snp.top).offset(3)
      make.leading.equalTo(contentView).offset(3)
      make.trailing.equalTo(contentView).offset(-3)
      make.bottom.equalTo(contentView.snp.bottom).offset(-20)
    }
    bookImageView.snp.makeConstraints { make in
      make.top.equalTo(diaryCellView.snp.top).offset(0)
      make.leading.equalTo(diaryCellView.snp.leading).offset(0)
      make.trailing.equalTo(diaryCellView.snp.trailing).offset(0)
      make.height.equalTo(135)
    }
    diaryTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(bookImageView.snp.bottom).offset(15)
      make.leading.equalTo(bookImageView).offset(14)
    }
    diaryDateLabel.snp.makeConstraints { make in
      make.top.equalTo(diaryTitleLabel.snp.bottom).offset(3)
      make.leading.equalTo(diaryTitleLabel.snp.leading)
      make.height.equalTo(11)
    }
    /*  gradient 이미지 값 추가하고 이 부분 수정 들어갑니다.
     //    shadowView.snp.makeConstraints { make in
     //      make.top.equalTo(bookImageView)
     //      make.leading.equalTo(bookImageView)
     //      make.trailing.equalTo(bookImageView)
     //      make.bottom.equalTo(bookImageView)}
     */
    bookTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(bookImageView).offset(10)
      make.leading.equalTo(bookImageView).offset(14)
      make.height.equalTo(12)
    }
    bookAuthorLabel.snp.makeConstraints { make in
      make.top.equalTo(bookImageView).offset(11)
      make.leading.equalTo(bookTitleLabel.snp.trailing).offset(4)
      make.height.equalTo(10)
    }
  }
}

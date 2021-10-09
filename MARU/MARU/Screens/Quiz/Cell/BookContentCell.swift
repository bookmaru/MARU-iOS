//
//  CreateQuiz1Cell.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/16.
//

import UIKit

import RxSwift

final class BookContentCell: UITableViewCell {

  private let bookContentView = UIView()
  private let bookImageView = UIImageView()
  private let bookNameLabel = UILabel()
  private let authorLabel = UILabel()
  private let oneLineIntroLabel = UILabel()
  fileprivate let oneLineTextView = UITextView()
  private let placeholder: String = "토론에 대한 소개를 50자 이내로 입력해주세요."
  var disposeBag = DisposeBag()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .white
    oneLineTextView.delegate = self
    configureComponent()
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
}
extension BookContentCell {

  private func configureComponent() {
    bookContentView.backgroundColor = .white
    bookContentView.layer.cornerRadius = 8
    bookContentView.applyShadow(
      color: .black16,
      alpha: 1,
      shadowX: 0,
      shadowY: 0,
      blur: 6
    )
    bookImageView.backgroundColor = .white
    bookNameLabel.text = "Default"
    authorLabel.text = "defalut"

    bookNameLabel.font = .systemFont(ofSize: 13, weight: .bold)
    authorLabel.font = .systemFont(ofSize: 10, weight: .medium)
    authorLabel.textColor = .brownGreyTwo

    oneLineIntroLabel.font = .systemFont(ofSize: 13, weight: .bold)
    oneLineIntroLabel.text = "한 줄 주제"

    oneLineTextView.font = .systemFont(ofSize: 13, weight: .bold)
    oneLineTextView.textColor = .lightGray
    oneLineTextView.text = placeholder
    oneLineTextView.backgroundColor = .white
    oneLineTextView.layer.cornerRadius = 8
    oneLineTextView.layer.borderWidth = 1
    oneLineTextView.layer.borderColor = UIColor.veryLightPink.cgColor
  }
  private func configureLayout() {
    contentView.adds([
      bookContentView,
      oneLineIntroLabel,
      oneLineTextView
    ])
    bookContentView.adds([
      bookImageView,
      bookNameLabel,
      authorLabel
    ])

    bookContentView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(3)
      make.size.equalTo(CGSize(width: 269.calculatedWidth, height: 170.calculatedHeight))
      make.centerX.equalToSuperview()
    }
    bookImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.bottom.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.45)
    }
    bookNameLabel.snp.makeConstraints { make in
      make.leading.equalTo(bookImageView.snp.trailing).offset(14)
      make.top.equalToSuperview().inset(13)
    }
    authorLabel.snp.makeConstraints { make in
      make.leading.equalTo(bookImageView.snp.trailing).offset(14)
      make.top.equalToSuperview().inset(36)
    }
    oneLineIntroLabel.snp.makeConstraints { make in
      make.top.equalTo(bookContentView.snp.bottom).offset(27.calculatedHeight)
      make.leading.equalToSuperview().inset(16)
    }
    oneLineTextView.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 343.calculatedWidth, height: 55.calculatedHeight))
      make.leading.equalToSuperview().inset(16)
      make.top.equalTo(oneLineIntroLabel.snp.bottom).offset(7)
    }
  }
}
extension BookContentCell {
  func bind(bookModel: BookModel) {
    bookImageView.image(url: bookModel.imageURL, defaultImage: Image.defalutImage ?? UIImage())
    bookNameLabel.text = bookModel.title
    authorLabel.text = bookModel.author
  }
}
extension BookContentCell: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == placeholder {
      textView.text = ""
      textView.textColor = .black
    }
  }
  func textViewDidChange(_ textView: UITextView) {
    if textView.text.count >= 51 {
      textView.deleteBackward()
    }
  }

}
extension Reactive where Base: BookContentCell {
  var changeText: Observable<String> {
    return base.oneLineTextView.rx.didChange
      .flatMapLatest { base.oneLineTextView.rx.text.orEmpty }
      .asObservable()
  }
}

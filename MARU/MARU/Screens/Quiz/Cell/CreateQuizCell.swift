//
//  CreateQuiz1Cell.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/16.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class CreateQuizCell: UITableViewCell {

  var disposeBag = DisposeBag()
  private let quizLabel = UILabel()
  private let maskingView = UIView()
  fileprivate let quizTextView = UITextView()
  fileprivate let oButton = UIButton()
  fileprivate let xButton = UIButton()
  private let placeholder: String = "퀴즈를 70자 이내로 입력해주세요."

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .white
    quizTextView.delegate = self
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
extension CreateQuizCell {
  private func configureComponent() {
    quizLabel.font = .systemFont(ofSize: 25, weight: .medium)

    maskingView.backgroundColor = .black22
    maskingView.layer.cornerRadius = 3
    maskingView.clipsToBounds = false

    quizTextView.font = .systemFont(ofSize: 13, weight: .bold)
    quizTextView.textColor = .lightGray
    quizTextView.text = placeholder
    quizTextView.backgroundColor = .white
    quizTextView.layer.cornerRadius = 8
    quizTextView.layer.borderWidth = 1
    quizTextView.layer.borderColor = UIColor.veryLightPink.cgColor

    oButton.setImage(Image.normalO, for: .normal)
    oButton.setImage(Image.tapO, for: .selected)
    oButton.setImage(Image.tapO, for: .highlighted)

    xButton.setImage(Image.normalX, for: .normal)
    xButton.setImage(Image.tapX, for: .selected)
    xButton.setImage(Image.tapX, for: .highlighted)
  }
  private func configureLayout() {
    contentView.adds([
      quizLabel,
      quizTextView,
      oButton,
      xButton
    ])
    quizLabel.add(maskingView)

    quizLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(1)
      make.leading.equalToSuperview().inset(16)
    }
    maskingView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(0.5)
      make.trailing.equalToSuperview().offset(0.5)
      make.bottom.equalToSuperview().inset(10)
      make.height.equalToSuperview().multipliedBy(0.3)
    }
    quizTextView.snp.makeConstraints { make in
      make.top.equalTo(quizLabel.snp.bottom).offset(14)
      make.centerX.equalToSuperview()
      make.size.equalTo(CGSize(width: 343.calculatedWidth, height: 55.calculatedHeight))
    }
    oButton.snp.makeConstraints { make in
      make.trailing.equalTo(contentView.snp.centerX).offset(-7)
      make.top.equalTo(quizTextView.snp.bottom).offset(15)
      make.size.equalTo(CGSize(width: 52, height: 52))
    }
    xButton.snp.makeConstraints { make in
      make.leading.equalTo(contentView.snp.centerX).offset(7)
      make.top.equalTo(quizTextView.snp.bottom).offset(15)
      make.size.equalTo(CGSize(width: 52, height: 52))
    }
  }
}
extension CreateQuizCell {
  func placeTextInQuizLabel(order: Int) {
    quizLabel.text = "Quiz " + "\(order + 1)"
  }
}
extension CreateQuizCell: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == placeholder {
      textView.text = ""
      textView.textColor = .black
    }
  }
  func textViewDidChange(_ textView: UITextView) {
    if textView.text.count >= 71 {
      textView.deleteBackward()
    }
  }
}

extension Reactive where Base: CreateQuizCell {
  enum QuizAction {
    case tapO
    case tapX
  }

  var didTapButton: Observable<String> {
    return Observable.merge(
      base.oButton.rx.tap.map { QuizAction.tapO },
      base.xButton.rx.tap.map { QuizAction.tapX }
    )
    .flatMapLatest({ action -> Observable<String> in
      switch action {
      case .tapO:
        base.oButton.isSelected = true
        base.xButton.isSelected = false
        return Observable.just("O")
      case .tapX:
        base.oButton.isSelected = false
        base.xButton.isSelected = true
        return Observable.just("X")
      }
    })
  }
  var changeText: Observable<String> {
    return base.quizTextView.rx.didChange
      .flatMapLatest { base.quizTextView.rx.text.orEmpty }
      .asObservable()
  }
}

//
//  CreateQuiz1Cell.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/16.
//

import UIKit

import RxSwift
import RxCocoa

enum Action {
  case tapO
  case tapX
}

class CreateQuizCell: UITableViewCell {
  var disposeBag = DisposeBag()
  private let quizLabel = UILabel()
  private let maskingView = UIView()
  let quizTextView = UITextView()
  let oButton = UIButton()
  let xButton = UIButton()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureComponent()
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
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
extension CreateQuizCell: UITextViewDelegate {
}
extension CreateQuizCell {
  func placeTextInQuizLabel(order: Int) {
    quizLabel.text = "Quiz " + "\(order + 1)"
  }
}

extension Reactive where Base: CreateQuizCell {
  var didTapButton: Observable<String> {
    return Observable.merge(
      base.oButton.rx.tap.map { Action.tapO },
      base.xButton.rx.tap.map { Action.tapX }
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
    .debug()
  }
}

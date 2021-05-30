//
//  QuizContentView.swift
//  MARU
//
//  Created by psychehose on 2021/04/11.
//

import UIKit

import Then

final class QuizContentView: UIView {

  private let quizMainLabel = UILabel().then {
    $0.textAlignment = .left
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 25, weight: .medium)
    $0.sizeToFit()
    $0.adjustsFontSizeToFitWidth = true
    $0.text = "default"
  }
  private let quizSequenceLabel = UILabel().then {
    $0.textAlignment = .left
    $0.textColor = .black22
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.sizeToFit()
    $0.adjustsFontSizeToFitWidth = true
    $0.text = "n of 5"
  }
  private let quizContentLabel =  UILabel().then {
    $0.text = "가나다라마바사 가나다라마바사 가나다라마바사 가나다라마바사 가나다라마바사"
    $0.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
    $0.textAlignment = .center
    $0.numberOfLines = 4
  }
  private let timerLabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = UIFont.systemFont(ofSize: 13)
    $0.text = "30"
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    applyConstraints()

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI Layout
extension QuizContentView {
  func applyConstraints() {
    adds([
      quizMainLabel,
      quizSequenceLabel,
      timerLabel,
      quizContentLabel
    ])
    quizMainLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top).inset(23)
      make.leading.equalTo(self.snp.leading).inset(23)
    }
    quizSequenceLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top).inset(29)
      make.leading.equalTo(quizMainLabel.snp.trailing).inset(-8)
    }
    timerLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top).inset(22)
      make.trailing.equalTo(self.snp.trailing).inset(19)
      make.height.equalTo(31)
      make.width.equalTo(31)
    }
    quizContentLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top).inset(133)
      make.leading.equalTo(self.snp.leading).inset(23)
      make.trailing.equalTo(self.snp.trailing).inset(23)
    }
  }
}
extension QuizContentView {
  func placeQuizManiLabelText(text: String) {
    quizMainLabel.text = text
  }
  func placeQuizSequence(numberString: String) {
    quizSequenceLabel.text = numberString + " of 5"
  }
  func placeQuizContentText(text: String) {
    quizContentLabel.text = text
  }
}

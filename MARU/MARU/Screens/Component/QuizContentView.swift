//
//  QuizContentView.swift
//  MARU
//
//  Created by psychehose on 2021/04/11.
//

import UIKit

import Then

final class QuizContentView: UIView {
  private let shadowView = UIView()
  private let quizNumberLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 25, weight: .medium)
    $0.text = "Quiz 1"
  }
  private let maskingView = UILabel().then {
    $0.backgroundColor = .black22
    $0.layer.cornerRadius = 3
    $0.clipsToBounds = false
  }
  private let quizSequenceLabel = UILabel().then {
    $0.textColor = .black22
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.text = "1 of 5"
  }
  private let quizContentLabel =  UILabel().then {
    $0.text = "가나다라마바사 가나다라마바사 가나다라마바사 가나다라마바사 가나다라마바사"
    $0.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
    $0.textAlignment = .center
    $0.numberOfLines = 4
  }
  let timerView = TimerView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    applyConstraints()
    applyShadow(color: UIColor.black,
                alpha: 0.16,
                shadowX: 0,
                shadowY: 0,
                blur: 6)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI Layout
extension QuizContentView {
  func applyConstraints() {
    adds([
      quizNumberLabel,
      quizSequenceLabel,
      timerView,
      quizContentLabel
    ])
    quizNumberLabel.add(maskingView)

    quizNumberLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(23)
      make.leading.equalToSuperview().inset(23)
    }
    quizSequenceLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(quizNumberLabel.snp.centerY)
      make.leading.equalTo(quizNumberLabel.snp.trailing).offset(8)
    }
    timerView.snp.makeConstraints { (make) in
      make.centerY.equalTo(quizNumberLabel.snp.centerY)
      make.trailing.equalToSuperview().inset(19)
      make.size.equalTo(CGSize(width: 31, height: 31))
    }
    quizContentLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(133)
      make.leading.equalToSuperview().inset(23)
      make.trailing.equalTo(self.snp.trailing).inset(23)
    }
    maskingView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(0.5)
      make.trailing.equalToSuperview().offset(0.5)
      make.bottom.equalToSuperview().inset(10)
      make.height.equalToSuperview().multipliedBy(0.3)
    }
  }
}
extension QuizContentView {
  func placeQuizNumberLabelText(numberString: String) {
    quizNumberLabel.text = "Quiz " + numberString
  }
  func placeQuizSequence(numberString: String) {
    quizSequenceLabel.text = numberString + " of 5"
  }
  func placeQuizContentText(text: String) {
    quizContentLabel.text = text
  }
  func startTimer(time: Int) {
    timerView.removeCountdown()
    timerView.setupTimer(time: time)
    timerView.startClockTimer()
  }
  func stopTimer() {
    timerView.removeCountdown()
  }
}

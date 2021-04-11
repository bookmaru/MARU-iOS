//
//  QuizContentView.swift
//  MARU
//
//  Created by psychehose on 2021/04/11.
//

import UIKit

import Then
class QuizContentView: UIView {
  
  private let quizMainLabel = UILabel().then {
    $0.textAlignment = .left
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 25, weight: .medium)
    $0.sizeToFit()
    $0.adjustsFontSizeToFitWidth = true
    $0.text = "default"
  }
  private let quizSequence = UILabel().then {
    $0.textAlignment = .left
    $0.textColor = .black22
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.sizeToFit()
    $0.adjustsFontSizeToFitWidth = true
    $0.text = "n of 5"
  }
  private let quizContent =  UILabel().then {
    $0.text = "가나다라마바사 가나다라마바사 가나다라마바사 가나다라마바사 가나다라마바사"
    $0.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
    $0.textAlignment = .center
    $0.numberOfLines = 4
  }
  private let timer = UILabel().then {
    $0.textAlignment = .center
    $0.font = UIFont.systemFont(ofSize: 13)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.applyShadow(color: UIColor(red: 0, green: 0, blue: 0),
                     alpha: 0.1607843137254902,
                     shadowX: 0,
                     shadowY: 0,
                     blur: 6)
    applyConstraints()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI Layout
extension QuizContentView {
  func applyConstraints() {
    self.adds([
      quizMainLabel,
      quizSequence,
      timer,
      quizContent
    ])
    quizMainLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top).inset(23)
      make.leading.equalTo(self.snp.leading).inset(23)
    }
    quizSequence.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top).inset(29)
      make.leading.equalTo(quizMainLabel.snp.trailing).inset(-8)
    }
    timer.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top).inset(22)
      make.trailing.equalTo(self.snp.trailing).inset(19)
      make.height.equalTo(31)
      make.width.equalTo(31)
    }
    quizContent.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top).inset(133)
      make.leading.equalTo(self.snp.leading).inset(23)
      make.trailing.equalTo(self.snp.trailing).inset(23)
    }
  }
}
extension QuizContentView {
  func setQuizManiLabelText(text: String) {
    quizMainLabel.text = text
  }
  func setQuizSequence(numberString: String) {
    quizSequence.text = numberString + " of 5"
  }
  func setQuizContentText(text: String) {
    quizContent.text = text
  }
}

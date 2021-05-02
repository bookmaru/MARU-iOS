//
//  QuizViewController.swift
//  MARU
//
//  Created by psychehose on 2021/04/11.
//

import UIKit

final class QuizViewController: UIViewController {
  lazy var quizContentView = QuizContentView().then { _ in
  }
  lazy var contentBackgroudView = UIView().then { _ in
  }
  let correctButton = UIButton().then {
    $0.setImage(UIImage(named: "correctWhite"), for: .normal)
  }
  let incorrectButton = UIButton().then {
    $0.setImage(UIImage(named: "incorrectWhite"), for: .normal)
    $0.backgroundColor = .blue
  }
  let quizFirstCheckImageView = UIImageView().then {
    $0.image = UIImage(named: "gray")
    $0.contentMode = .center
  }
  let quizSecondCheckImageView = UIImageView().then {
    $0.image = UIImage(named: "gray")
    $0.contentMode = .center
  }
  let quizThirdCheckImageView = UIImageView().then {
    $0.image = UIImage(named: "gray")
    $0.contentMode = .center
  }
  let quizFourthCheckImageView = UIImageView().then {
    $0.image = UIImage(named: "gray")
    $0.contentMode = .center
  }
  let quizFifthCheckImageView = UIImageView().then {
    $0.image = UIImage(named: "gray")
    $0.contentMode = .center
  }
  let screenSize = UIScreen.main.bounds.size

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    applyLayout()
  }

}

extension QuizViewController {
  private func applyLayout() {
    self.view.adds([
      contentBackgroudView,
      quizContentView,
      correctButton,
      incorrectButton
    ])
    self.view.adds([
      quizFirstCheckImageView,
      quizSecondCheckImageView,
      quizThirdCheckImageView,
      quizFourthCheckImageView,
      quizFifthCheckImageView
    ])

    contentBackgroudView.applyQuizViewShadow()
    quizContentView.applyQuizViewShadow()

    correctButton.snp.makeConstraints { (make) in
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(90)
      make.leading.equalTo(view.safeAreaLayoutGuide).inset(78)
      make.size.equalTo(CGSize(width: 90, height: 90))
    }
    incorrectButton.snp.makeConstraints { (make) in
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(90)
      make.trailing.equalTo(view.safeAreaLayoutGuide).inset(78)
      make.size.equalTo(CGSize(width: 90, height: 90))
    }
    contentBackgroudView.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: screenSize.width * (0.824),
                               height: screenSize.height * (0.345)))
      make.trailing.equalTo(view.snp.trailing).inset(screenSize.width * 0.061)
      make.bottom.equalTo(correctButton.snp.top).inset(-60)
    }
    quizContentView.snp.makeConstraints { (make) in
      make.size.equalTo(contentBackgroudView)
      make.trailing.equalTo(contentBackgroudView.snp.trailing).inset(10)
      make.bottom.equalTo(contentBackgroudView.snp.bottom).inset(10)
    }
    quizThirdCheckImageView.snp.makeConstraints { ( make ) in
      make.centerX.equalTo(view.snp.centerX)
      make.bottom.equalTo(quizContentView.snp.top).inset(-15)
      make.size.equalTo(CGSize(width: 20, height: 20))
    }
    quizSecondCheckImageView.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 20, height: 20))
      make.centerY.equalTo(quizThirdCheckImageView.snp.centerY)
      make.trailing.equalTo(quizThirdCheckImageView.snp.leading).inset(-2)
    }
    quizFourthCheckImageView.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 20, height: 20))
      make.centerY.equalTo(quizThirdCheckImageView.snp.centerY)
      make.leading.equalTo(quizThirdCheckImageView.snp.trailing).inset(-2)
    }
    quizFirstCheckImageView.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 20, height: 20))
      make.centerY.equalTo(quizThirdCheckImageView.snp.centerY)
      make.trailing.equalTo(quizSecondCheckImageView.snp.leading).inset(-2)
    }
    quizFifthCheckImageView.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 20, height: 20))
      make.centerY.equalTo(quizThirdCheckImageView.snp.centerY)
      make.leading.equalTo(quizFourthCheckImageView.snp.trailing).inset(-2)
    }
  }
  // MARK: - 5월 3일 할 일
  private func bind() {
  }
}

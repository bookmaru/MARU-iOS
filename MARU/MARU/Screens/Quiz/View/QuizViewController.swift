//
//  QuizViewController.swift
//  MARU
//
//  Created by psychehose on 2021/04/11.
//

import UIKit

import RxSwift
import RxCocoa

final class QuizViewController: BaseViewController {
  private let quizContentView = QuizContentView()
  private let contentBackgroudView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.applyShadow(color: UIColor.black,
                     alpha: 0.16,
                     shadowX: 0,
                     shadowY: 0,
                     blur: 6)
    return view
  }()
  private let correctButton: UIButton = {
    let button = UIButton()
    button.setImage(Image.normalO, for: .normal)
    button.setImage(Image.tapO, for: .selected)
    button.setImage(Image.tapO, for: .highlighted)
    button.addTarget(self, action: #selector(tapButton(_ :)), for: .touchUpInside)
    button.tag = 0
    return button
  }()
  private let incorrectButton: UIButton = {
    let button = UIButton()
    button.setImage(Image.normalX, for: .normal)
    button.setImage(Image.tapX, for: .selected)
    button.setImage(Image.tapX, for: .highlighted)
    button.addTarget(self, action: #selector(tapButton(_ :)), for: .touchUpInside)
    button.tag = 1
    return button
  }()
  private let firstMarkImageView = UIImageView()
  private let secondMarkImageView = UIImageView()
  private let thirdMarkImageView = UIImageView()
  private let fourthMarkImageView = UIImageView()
  private let fifthMarkImageView = UIImageView()
  lazy private var markImageViews: [UIImageView] = [
    firstMarkImageView,
    secondMarkImageView,
    thirdMarkImageView,
    fourthMarkImageView,
    fifthMarkImageView
  ]
  private var groupID: Int
  private let viewModel = QuizViewModel()
  private var quizsContent: [String] = []
  private let timeoutTrigger = PublishSubject<Void>()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .quizBackgroundColor
    quizContentView.timerView.delegate = self
    configureImageView()
    configureLayout()
    bind()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: true)
  }
  init(groupID: Int) {
    self.groupID = groupID
    super.init()
    print(groupID)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func bind() {
    let viewWillAppear = Observable
      .combineLatest(
        rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
          .asObservable()
          .map { _ in }
          .asObservable(),
        Observable.just(groupID)
      )
    let buttonAction = Driver.merge(
      Driver.combineLatest(correctButton.rx.isButtonSelected.asDriver(), Driver.just("O")),
      Driver.combineLatest(incorrectButton.rx.isButtonSelected.asDriver(), Driver.just("X"))
    )

    let input = QuizViewModel.Input(
      viewTrigger: viewWillAppear,
      tapButton: buttonAction,
      timeout: timeoutTrigger.asDriver(onErrorJustReturn: ())
    )

    let output = viewModel.transform(input: input)
    output.load
      .drive()
      .disposed(by: disposeBag)

    output.judge
      .drive { [weak self] _ in
        guard let self = self else { return }
        self.deselectAllButton()
        self.isEnabledAllButton(isUserInteractionEnabled: true)
      }
      .disposed(by: disposeBag)

    output.timeout
      .drive()
      .disposed(by: disposeBag)
    output.contentAndIndex
      .drive(onNext: { [weak self] contentAndIndex  in
        guard let self = self else { return }
        if contentAndIndex.isPass == true {
          self.setupContentView(
            content: contentAndIndex.content,
            index: contentAndIndex.index
          )
          self.quizContentView.startTimer(time: 30)
        }
      })
      .disposed(by: disposeBag)

    output.checkMarker
      .drive(onNext: { [weak self] solve, index in
        guard let self = self else { return }
        self.setupMarkImageView(index: index, isCorrect: solve)
      })
      .disposed(by: disposeBag)

    output.isPass
      .drive(onNext: { [weak self] in
        guard let self = self else { return }
        let resultViewController = QuizResultViewController()
        resultViewController.modalPresentationStyle = .fullScreen
        resultViewController.backgroundImage = self.view.asImage()
        resultViewController.groupID = self.groupID
        self.quizContentView.stopTimer()

        if $0 == true {
          resultViewController.result = .success
          self.present(resultViewController, animated: false, completion: nil)
        }
        if $0 == false {
          resultViewController.result = .failure
          self.quizContentView.stopTimer()
          self.present(resultViewController, animated: false, completion: nil)
        }
      })
      .disposed(by: disposeBag)
  }
}

extension QuizViewController {
  private func setupMarkImageView(index: Int, isCorrect: Bool) {
    if isCorrect {
      markImageViews[index].image = Image.correct
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
        self?.markImageViews[index].image = Image.checkgray
      })
    } else {
      markImageViews[index].image = Image.wrongRed
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
        self?.markImageViews[index].image = Image.wrongGray
      })
    }
  }
  private func setupContentView(content: String, index: Int) {
    quizContentView.placeQuizContentText(text: content)
    quizContentView.placeQuizSequence(numberString: (index + 1).string)
    quizContentView.placeQuizNumberLabelText(numberString: (index + 1).string)
  }

  @objc
  private func tapButton(_ sender: UIButton) {
    sender.isSelected = true
    isEnabledAllButton(isUserInteractionEnabled: false)
  }
  private func isEnabledAllButton(isUserInteractionEnabled: Bool) {
    view.subviews.forEach({ ($0 as? UIButton)?.isUserInteractionEnabled = isUserInteractionEnabled })
  }
  private func deselectAllButton() {
    view.subviews.forEach({ ($0 as? UIButton)?.isSelected = false })
  }
  private func configureImageView() {
    markImageViews.forEach { imageView in
      imageView.image = Image.gray
    }
  }

  private func configureLayout() {
    view.adds([
      contentBackgroudView,
      quizContentView,
      correctButton,
      incorrectButton
    ])
    view.adds([
      firstMarkImageView,
      secondMarkImageView,
      thirdMarkImageView,
      fourthMarkImageView,
      fifthMarkImageView
    ])

    correctButton.snp.makeConstraints { (make) in
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(90.calculatedHeight)
      make.trailing.equalTo(view.snp.centerX).offset(-20)
      make.size.equalTo(CGSize(width: 90, height: 90))
    }
    incorrectButton.snp.makeConstraints { (make) in
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(90.calculatedHeight)
      make.leading.equalTo(view.snp.centerX).offset(20)
      make.size.equalTo(CGSize(width: 90, height: 90))
    }
    contentBackgroudView.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 309.calculatedWidth, height: 280.calculatedHeight))
      make.trailing.equalToSuperview().inset(23)
      make.bottom.equalTo(correctButton.snp.top).inset(-60.calculatedHeight)
    }
    quizContentView.snp.makeConstraints { (make) in
      make.size.equalTo(contentBackgroudView)
      make.trailing.equalTo(contentBackgroudView.snp.trailing).inset(10)
      make.bottom.equalTo(contentBackgroudView.snp.bottom).inset(10)
    }
    thirdMarkImageView.snp.makeConstraints { (make) in
      make.centerX.equalTo(view.snp.centerX)
      make.bottom.equalTo(quizContentView.snp.top).inset(-15)
      make.size.equalTo(CGSize(width: 20, height: 20))
    }
    secondMarkImageView.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 20, height: 20))
      make.centerY.equalTo(thirdMarkImageView.snp.centerY)
      make.trailing.equalTo(thirdMarkImageView.snp.leading).inset(-2)
    }
    fourthMarkImageView.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 20, height: 20))
      make.centerY.equalTo(thirdMarkImageView.snp.centerY)
      make.leading.equalTo(thirdMarkImageView.snp.trailing).inset(-2)
    }
    firstMarkImageView.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 20, height: 20))
      make.centerY.equalTo(thirdMarkImageView.snp.centerY)
      make.trailing.equalTo(secondMarkImageView.snp.leading).inset(-2)
    }
    fifthMarkImageView.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 20, height: 20))
      make.centerY.equalTo(thirdMarkImageView.snp.centerY)
      make.leading.equalTo(fourthMarkImageView.snp.trailing).inset(-2)
    }
  }
}
extension QuizViewController: Timeout {
  func timeout() {
    timeoutTrigger.onNext(())
  }
}
extension Reactive where Base: UIButton {
  var isButtonSelected: ControlProperty<Bool> {
    return base.rx.controlProperty(
      editingEvents: [.touchUpInside],
      getter: { $0.isSelected },
      setter: { $0.isSelected = $1 }
    )
  }
}

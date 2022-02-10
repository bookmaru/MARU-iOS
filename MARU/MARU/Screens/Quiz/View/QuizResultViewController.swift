//
//  QuizResultViewController.swift
//  MARU
//
//  Created by psychehose on 2021/08/23.
//

import UIKit

import RxCocoa
import RxSwift

final class QuizResultViewController: BaseViewController {

  enum Result: Int {
    case success = 0
    case failure = 1

    func simpleDescription() -> String {
      switch self {
      case .success:
        return "true"
      case .failure:
        return "false"
      }
    }
  }

  private let backgroundImageView = UIImageView()
  private let dimmerView = UIView()
  private let popupView = UIView()
  private let emoticonLabel = UILabel()
  private let titleLabel = UILabel()
  private let subLabel = UILabel()
  private let okButton = UIButton()
  var backgroundImage: UIImage? {
    didSet {
      backgroundImageView.image = backgroundImage
    }
  }
  var groupID = Int.min
  var result: Result = Result.failure

  private let emoticon: [String] = ["🎉", "😭"]
  private let titleString: [String] = [
    "3문제 이상 맞히셨네요!",
    "앗 3문제 이상 틀리셨네요."
  ]
  private let subString: [String] = [
    """
    이 책에 대해 잘 알고 계시군요!
    이제 책에 대한 다양한 해석과
    이야기를 나눠보세요.
    """,

    """
    아쉽게도 입장하실 수 없습니다.
    다른 방에 도전하거나
    직접 방을 만들어보세요!
    """
  ]
  private let viewModel = QuizResultViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureComponent(result: result)
    configureLayout()
    bind()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    showPopupView()
  }
  private func bind() {
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
          .asObservable()
          .map { _ in }
          .asObservable()

    let resultValue =
      BehaviorSubject<(Int, String)>(
        value: (groupID, result.simpleDescription())
      )
      .asObservable()

    let input = QuizResultViewModel.Input(
      viewTrigger: viewWillAppear,
      resultValue: resultValue,
      tapOk: okButton.rx.tap.asObservable()
    )
    let output = viewModel.transform(input: input)

    output.response
      .drive()
      .disposed(by: disposeBag)
    output.goMain
      .drive(onNext: { [weak self] in
        guard let self = self else { return }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: {
          let tabbarViewController = TabBarController()
          tabbarViewController.modalPresentationStyle = .fullScreen
          if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController?.present(tabbarViewController, animated: false, completion: nil)
          }
        })
      })
      .disposed(by: disposeBag)
  }
}

extension QuizResultViewController {
  private func goMain() {
    dismiss(animated: false, completion: nil)
  }
  private func showPopupView() {

    self.popupView.snp.updateConstraints { update in
      update.top.equalToSuperview().offset(225.calculatedHeight)
    }

    let showPopupView = UIViewPropertyAnimator(
      duration: 0.5,
      curve: .easeIn,
      animations: {
        self.view.layoutIfNeeded()
      })

    showPopupView.addAnimations {
      self.dimmerView.backgroundColor = .black30
    }
    showPopupView.startAnimation()
  }
  private func configureComponent(result: Result) {
    dimmerView.backgroundColor = .white

    popupView.backgroundColor = .white
    popupView.layer.masksToBounds = true
    popupView.layer.cornerRadius = 8

    emoticonLabel.text = "😭"
    emoticonLabel.font = .systemFont(ofSize: 30, weight: .bold)

    titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)

    subLabel.font = .systemFont(ofSize: 15, weight: .light)
    subLabel.numberOfLines = 3
    subLabel.textAlignment = .center

    okButton.backgroundColor = .mainBlue
    okButton.setTitle("네, 알겠어요.", for: .normal)
    okButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    okButton.titleLabel?.textAlignment = .center
    okButton.setTitleColor(.white, for: .normal)

    titleLabel.text = titleString[result.rawValue]
    subLabel.text = subString[result.rawValue]
    emoticonLabel.text = emoticon[result.rawValue]
  }

  private func configureLayout() {
    view.adds([
      backgroundImageView,
      popupView
    ])

    backgroundImageView.add(dimmerView)

    popupView.adds([
      emoticonLabel,
      titleLabel,
      subLabel,
      okButton
    ])

    backgroundImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    dimmerView.snp.makeConstraints { make in
      make.top.equalTo(view.snp.top)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    popupView.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 308.calculatedWidth, height: 283))
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(+ScreenSize.height)
    }

    emoticonLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(35)
      make.centerX.equalToSuperview()
    }
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(emoticonLabel.snp.bottom).offset(13)
    }
    subLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(26)
    }
    okButton.snp.makeConstraints { make in
      make.top.equalTo(subLabel.snp.bottom).offset(40)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
}

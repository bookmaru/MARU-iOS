//
//  CreateQuizViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/09.
//

import UIKit

import RxSwift
import RxCocoa

final class CreateQuizViewController: BaseViewController {

  init(bookModel: BookModel) {
    self.bookModel = bookModel
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let bookModel: BookModel
  private var tableView: UITableView! = nil
  private let headerView: UIView = {
    let view = UIView()
    let label = UILabel()
    label.text = "퀴즈 작성"
    label.font = .systemFont(ofSize: 13, weight: .bold)
    view.add(label) {
      $0.snp.makeConstraints { make in
        make.bottom.equalToSuperview().inset(8)
        make.leading.equalToSuperview().inset(16)
      }
    }
    return view
  }()
  private let cancelButton: UIButton = {
    let cancelButton = UIButton()
    cancelButton.tintColor = .black
    cancelButton.setImage(
      UIImage(systemName: "xmark")?
        .withConfiguration(UIImage.SymbolConfiguration(weight: .medium)),
      for: .normal
    )
    return cancelButton
  }()
  private let completeButton: UIButton = {
    let completeButton = UIButton()
    completeButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
    completeButton.setTitleColor(.mainBlue, for: .normal)
    completeButton.setTitleColor(.gray, for: .disabled)
    completeButton.setTitle("완료", for: .normal)
//    completeButton.isEnabled = false
    return completeButton
  }()
  private let oneLinePlaceholder = "토론에 대한 소개를 70자 이내로 입력해주세요."
  private var oneLineString: String?
  private let triggerQuizProblem = PublishSubject<(String, Int)>()
  private let triggerQuizAnswer = PublishSubject<(String, Int)>()
  private let triggerDescription = PublishSubject<String>()
//  private let viewModel = CreateQuizViewModel()
  lazy var viewModel = CreateQuizViewModel(dependency: .init(bookModel: bookModel))

  override func viewDidLoad() {
    super.viewDidLoad()
    KeychainHandler.shared.accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwiZXhwIjoxNjMzMjcyMzU3fQ.Az8sUq84buQSXK5y3jrXSiA6DybdAKZge-iz0Tzr-2M"
    configureComponent()
    configureLayout()
    bind()
  }
  private func bind() {
    let viewTrigger = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in }
      .asObservable()

    let input = CreateQuizViewModel.Input(
      viewTrigger: viewTrigger,
      tapCancleButton: cancelButton.rx.tap.asObservable(),
      tapCompleteButton: completeButton.rx.tap.asObservable(),
      description: triggerDescription.asObservable(),
      quizProblem: triggerQuizProblem.asObservable(),
      quizAnswer: triggerQuizAnswer.asObservable()
    )

    let output = viewModel.transform(input: input)

    output.description
      .drive()
      .disposed(by: disposeBag)
    output.quizProblem
      .drive()
      .disposed(by: disposeBag)
    output.quizAnswer
      .drive()
      .disposed(by: disposeBag)
    output.didTapCancle
      .drive()
      .disposed(by: disposeBag)
    output.didTapComplement
      .drive()
      .disposed(by: disposeBag)
  }
}
extension CreateQuizViewController {
  private func configureComponent() {
    tableView = UITableView(frame: .zero, style: .grouped)
    tableView.backgroundColor = .white
    tableView.register(
      CreateQuizCell.self,
      forCellReuseIdentifier: CreateQuizCell.reuseIdentifier
    )
    tableView.register(
      BookContentCell.self,
      forCellReuseIdentifier: BookContentCell.reuseIdentifier
    )
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelection = false
  }
  private func configureLayout() {
    view.addSubview(tableView)
    view.adds([
      cancelButton,
      completeButton
    ])

    cancelButton.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 16, height: 16))
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(14.calculatedHeight)
      make.leading.equalToSuperview().inset(17.calculatedWidth)
    }
    completeButton.snp.makeConstraints { make in
      make.centerY.equalTo(cancelButton.snp.centerY)
      make.trailing.equalToSuperview().inset(16.calculatedWidth)
    }

    tableView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(68.calculatedHeight)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaInsets.bottom).inset(5)
    }
  }
}

extension CreateQuizViewController: UITableViewDelegate { }
extension CreateQuizViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 5
    default:
      return 0
    }
  }
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(
              withIdentifier: BookContentCell.reuseIdentifier,
              for: indexPath) as? BookContentCell else { return UITableViewCell() }

      cell.oneLineTextView.rx.didChange.asObservable()
        .flatMapLatest(cell.oneLineTextView.rx.text.orEmpty.asObservable)
        .subscribe(onNext: { [weak self] oneLineDescription in
          self?.triggerDescription.onNext(oneLineDescription)
          print(oneLineDescription)
        })
        .disposed(by: cell.disposeBag)
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(
              withIdentifier: CreateQuizCell.reuseIdentifier,
              for: indexPath) as? CreateQuizCell else { return UITableViewCell() }
      cell.placeTextInQuizLabel(order: indexPath.item)

      cell.quizTextView.rx.didChange.asObservable()
        .flatMapLatest(cell.quizTextView.rx.text.orEmpty.asObservable)
        .subscribe(onNext: { [weak self] quizProblem in
          self?.triggerQuizProblem.onNext((quizProblem, indexPath.item))
          print(quizProblem, indexPath.item)
        })
        .disposed(by: cell.disposeBag)

      cell.rx.didTapButton
        .subscribe(onNext: { [weak self] quizAnswer in
          self?.triggerQuizAnswer.onNext((quizAnswer, indexPath.item))
          print(quizAnswer, indexPath.item)
        })
        .disposed(by: cell.disposeBag)
      return cell

    default:
      return UITableViewCell()
    }

  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 280.calculatedHeight
    case 1:
      return 170.calculatedHeight
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 0
    case 1:
      return 50.calculatedHeight
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 0
    case 1:
      return 10
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return headerView
  }
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }
}

extension CreateQuizViewController: UITextViewDelegate { }

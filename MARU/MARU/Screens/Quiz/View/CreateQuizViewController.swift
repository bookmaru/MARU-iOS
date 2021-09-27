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

  private let bookModel: BookModel
  private var tableView: UITableView! = nil
  private let cancelButton: UIBarButtonItem = {
    let cancelButton = UIBarButtonItem()
    cancelButton.tintColor = .black
    cancelButton.image = UIImage(systemName: "xmark")?
      .withConfiguration(UIImage.SymbolConfiguration(weight: .medium))
    return cancelButton
  }()
  private let completeButton: UIBarButtonItem = {
    let completeButton = UIBarButtonItem()
    completeButton.title = "완료"
    let normalAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12, weight: .bold),
      .foregroundColor: UIColor.mainBlue
    ]
    let disabledAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12, weight: .bold),
      .foregroundColor: UIColor.gray
    ]
    completeButton.setTitleTextAttributes(normalAttributes, for: .normal)
    completeButton.setTitleTextAttributes(disabledAttributes, for: .disabled)

    // TO DO: false로 바꾸고 모든 빈칸이 채워졌을 때, true로 바꾸는 거 추후에 구현
    completeButton.isEnabled = true
    return completeButton
  }()
  private let oneLinePlaceholder = "토론에 대한 소개를 70자 이내로 입력해주세요."
  private var oneLineString: String?
  private let triggerQuizProblem = PublishSubject<(String, Int)>()
  private let triggerQuizAnswer = PublishSubject<(String, Int)>()
  private let triggerDescription = PublishSubject<String>()
  lazy var viewModel = CreateQuizViewModel(dependency: .init(bookModel: bookModel))

  init(bookModel: BookModel) {
    self.bookModel = bookModel
    super.init()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureComponent()
    configureLayout()
    bind()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: false)
    configureNavigationBar()
  }
  private func configureNavigationBar() {
    navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    navigationController?.navigationBar.isTranslucent = false
    navigationItem.leftBarButtonItem = cancelButton
    navigationItem.rightBarButtonItem = completeButton
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
    // TO DO: Cancle button 클릭시 dismiss
    output.didTapCancle
      .drive()
      .disposed(by: disposeBag)
    // To do: Complement Click 채팅 화면으로 이동
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
    view.add(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
              for: indexPath
      ) as? BookContentCell else { return UITableViewCell() }

      cell.rx.changeText
        .subscribe(onNext: { [weak self] oneLineDescription in
          self?.triggerDescription.onNext(oneLineDescription)
        })
        .disposed(by: cell.disposeBag)
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(
              withIdentifier: CreateQuizCell.reuseIdentifier,
              for: indexPath
      ) as? CreateQuizCell else { return UITableViewCell() }
      cell.placeTextInQuizLabel(order: indexPath.item)

      cell.rx.changeText
        .subscribe(onNext: { [weak self] quizProblem in
          self?.triggerQuizProblem.onNext((quizProblem, indexPath.item))
        })
        .disposed(by: cell.disposeBag)

      cell.rx.didTapButton
        .subscribe(onNext: { [weak self] quizAnswer in
          self?.triggerQuizAnswer.onNext((quizAnswer, indexPath.item))
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

     let headerView: UIView = {
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
    return headerView
  }
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }
}

extension CreateQuizViewController: UITextViewDelegate { }

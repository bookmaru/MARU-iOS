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

  override var hidesBottomBarWhenPushed: Bool {
    get { navigationController?.topViewController == self }
    set { super.hidesBottomBarWhenPushed = newValue }
  }

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
    completeButton.isEnabled = false
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
    configureNavigationBar()
    bind()
    addTapGestureOnTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: false)
    registerKeyboardNotification()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(false)
    unregisterKeyboardNotification()
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
    output.didTapCancle
      .drive { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
    output.tappableComplement
      .drive(onNext: { [weak self] enabled in
        self?.completeButton.isEnabled = enabled
      })
      .disposed(by: disposeBag)
    output.didTapComplement
      .drive(onNext: { groupID in
        self.view.window?.rootViewController?.dismiss(animated: true, completion: {
          ChatService.shared.createRoom(roomID: groupID)
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
    tableView.keyboardDismissMode = .interactive
    tableView.contentInsetAdjustmentBehavior = .never
  }

  private func configureLayout() {
    extendedLayoutIncludesOpaqueBars = true
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
      cell.selectionStyle = .none
      cell.bind(bookModel: bookModel)
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
      cell.selectionStyle = .none
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

extension CreateQuizViewController {

  func addTapGestureOnTableView() {
    let taps = UITapGestureRecognizer(target: self, action: #selector(didTapTableView))
    tableView.addGestureRecognizer(taps)
  }
  @objc
  func didTapTableView() {
    view.endEditing(true)
  }
  private func registerKeyboardNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  private func unregisterKeyboardNotification() {
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  @objc
  func keyboardWillShow(_ notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    }
  }
  @objc
  func keyboardWillHide(_ notification: Notification) {
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}

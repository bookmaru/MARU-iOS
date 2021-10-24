//
//  DiaryViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/10/11.
//

import UIKit

import RxCocoa
import RxSwift
import Then

final class DiaryViewController: BaseViewController {

  override var hidesBottomBarWhenPushed: Bool {
    get { navigationController?.topViewController == self }
    set { super.hidesBottomBarWhenPushed = newValue }
  }

  private let imageView = UIImageView()
  private let bookTitleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
  }
  private let dateLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
  }
  private let dotView = UIView().then {
    $0.backgroundColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)
    $0.layer.cornerRadius = 3
  }
  private let titleLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 15, weight: .bold)
  }
  private let contentLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textAlignment = .center
    $0.numberOfLines = 26
  }
  private let editButton = UIBarButtonItem(
    title: "편집",
    style: .done,
    target: self,
    action: nil
  )

  private let viewModel: DiaryViewModel

  private var info: DiaryInfo? {
    didSet {
      guard let info = info else { return }
      imageView.image(url: info.bookImage)
      bookTitleLabel.text = "\(info.bookTitle) / \(info.bookAuthor)"
      dateLabel.text = info.createdAt
      titleLabel.text = info.diaryTitle
      contentLabel.text = info.content
    }
  }

  private var group: Group?

  init(diaryID: Int) {
    viewModel = DiaryViewModel(diaryID: diaryID)
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    render()
    setupNavigation()
    bind()
    buttonBind()
  }

  private func bind() {
    let viewDidLoad = rx.methodInvoked(#selector(viewDidAppear(_:)))
      .map { _ in }

    let input = DiaryViewModel.Input(viewDidLoad: viewDidLoad)
    let output = viewModel.transform(input: input)

    output.info
      .subscribe(onNext: { [weak self] info in
        guard let self = self else { return }
        self.info = info
      })
      .disposed(by: disposeBag)

    output.group
      .subscribe(onNext: { [weak self] group in
        guard let self = self else { return }
        self.group = group
      })
      .disposed(by: disposeBag)
  }

  private func buttonBind() {
    editButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        guard let self = self,
              let info = self.info,
              let group = self.group
        else { return }
        let viewController = DiaryWriteViewController(diary: group, info: info)
        self.navigationController?.pushViewController(viewController, animated: true)
      })
      .disposed(by: disposeBag)
  }

  private func render() {

    view.adds([
      imageView,
      bookTitleLabel,
      dateLabel,
      dotView,
      titleLabel,
      contentLabel
    ])
    imageView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(96)
      $0.height.equalTo(142)
    }
    bookTitleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(12)
      $0.centerX.equalToSuperview()
    }
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(bookTitleLabel.snp.bottom).offset(6)
      $0.centerX.equalToSuperview()
    }
    dotView.snp.makeConstraints {
      $0.top.equalTo(dateLabel.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(6)
    }
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(dotView.snp.bottom).offset(24)
      $0.centerX.equalToSuperview()
    }
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(34)
      $0.centerX.equalToSuperview()
    }
  }

  private func setupNavigation() {
    title = "내 일기장"

    navigationItem.rightBarButtonItem = editButton
    navigationController?.navigationBar.isHidden = false
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    guard let navigationBar = navigationController?.navigationBar else { return }
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
  }
}

extension DiaryViewController: UIGestureRecognizerDelegate { }

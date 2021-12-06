//
//  DiaryWriteViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/09/19.
//

import UIKit

import RxCocoa
import RxSwift

final class DiaryWriteViewController: BaseViewController {

  override var hidesBottomBarWhenPushed: Bool {
    get { navigationController?.topViewController == self }
    set { super.hidesBottomBarWhenPushed = newValue }
  }

  private let scrollView = UIScrollView()
  private let diaryView = DiaryView()
  private let titleContainerView = UIView().then {
    $0.layer.cornerRadius = 12
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor(red: 239, green: 239, blue: 239).cgColor
    $0.backgroundColor = .white
  }
  private let titleTextView = UITextField().then {
    $0.placeholder = "제목"
    $0.font = .systemFont(ofSize: 12, weight: .semibold)
  }
  private let diaryTextContainerView = UIView().then {
    $0.layer.cornerRadius = 12
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor(red: 239, green: 239, blue: 239).cgColor
    $0.backgroundColor = .white
  }
  private let diaryTextView = UITextView().then {
    $0.text = "일기쓰기"
    $0.font = .systemFont(ofSize: 12, weight: .semibold)
    $0.textColor = .veryLightPink
  }
  private let doneButton = UIBarButtonItem().then {
    $0.title = "완료"
    $0.tintColor = .mainBlue
    $0.style = .done
    $0.isEnabled = false
  }

  private let viewModel: DiaryWriteViewModel

  private let isDiaryEdit: Bool

  init(diary: Group, isDiaryEdit: Bool = false, info: DiaryInfo? = nil) {
    viewModel = DiaryWriteViewModel(groupID: diary.discussionGroupID, info: info, isDiaryEdit: isDiaryEdit)
    self.isDiaryEdit = isDiaryEdit
    super.init()

    diaryView.rx.dataBinder.onNext(diary)
    textBinder()
    setInfo(info: info)
  }

  convenience init(diary: Group, info: DiaryInfo) {
    self.init(diary: diary, isDiaryEdit: true, info: info)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    bind()
  }

  private func setInfo(info: DiaryInfo?) {
    guard let info = info, isDiaryEdit else { return }
    titleTextView.text = info.diaryTitle
    diaryTextView.text = info.content
  }

  private func render() {
    title = "독서일기 쓰기"

    navigationItem.rightBarButtonItem = doneButton

    view.add(scrollView)
    let contentView = UIView()
    scrollView.add(contentView)
    contentView.add(diaryView)
    contentView.add(titleContainerView)
    titleContainerView.add(titleTextView)
    contentView.add(diaryTextContainerView)
    diaryTextContainerView.add(diaryTextView)
    scrollView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    contentView.snp.makeConstraints {
      $0.edges.equalTo(scrollView.snp.edges)
      $0.height.greaterThanOrEqualTo(scrollView)
      $0.width.equalTo(scrollView)
    }
    diaryView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(142)
    }
    titleContainerView.snp.makeConstraints {
      $0.leading.trailing.equalTo(diaryView)
      $0.top.equalTo(diaryView.snp.bottom).offset(26)
      $0.height.equalTo(40)
    }
    titleTextView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(14)
      $0.bottom.equalToSuperview().inset(13)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    diaryTextContainerView.snp.makeConstraints {
      $0.top.equalTo(titleContainerView.snp.bottom).offset(16)
      $0.leading.trailing.equalTo(diaryView)
      $0.bottom.equalToSuperview().inset(48)
    }
    diaryTextView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(16)
    }
  }

  private func textBinder() {
    diaryTextView.rx.didEndEditing
      .map { self.diaryTextView.text }
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        if text == nil || text == "" {
          self.diaryTextView.text = "일기쓰기"
          self.diaryTextView.textColor = .veryLightPink
        }
      })
      .disposed(by: disposeBag)

    diaryTextView.rx.didBeginEditing
      .map { self.diaryTextView.text }
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        if text == "일기쓰기" {
          self.diaryTextView.text = ""
          self.diaryTextView.textColor = .black
        }
      })
      .disposed(by: disposeBag)

    Observable.combineLatest(titleTextView.rx.text, diaryTextView.rx.text)
      .subscribe(onNext: { [weak self] title, diary in
        guard let self = self else { return }
        let canDone = title != "" && diary != "일기쓰기" && diary != ""
        self.doneButton.isEnabled = canDone
      })
      .disposed(by: disposeBag)

    scrollView.rx.tapGesture()
      .when(.recognized)
      .subscribe(onNext: { _ in
        self.view.endEditing(true)
      })
      .disposed(by: disposeBag)
  }

  private func bind() {
    let didTapDoneButton = doneButton.rx.tap
      .map { [weak self] _ -> (title: String, content: String) in
        guard let self = self,
              let title = self.titleTextView.text,
              let content = self.diaryTextView.text
        else { return (title: "", content: "") }
        return (title: title, content: content)
      }

    let input = DiaryWriteViewModel.Input(didTapDoneButton: didTapDoneButton)
    let output = viewModel.transform(input: input)

    output.isSuccess
      .subscribe(onNext: { [weak self] isSuccess in
        guard let self = self else { return }
        if !isSuccess {
          self.showToast("에러가 발생했습니다.")
          return
        }
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
}

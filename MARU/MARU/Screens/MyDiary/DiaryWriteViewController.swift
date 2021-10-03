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

  private let scrollView = UIScrollView()
  private let diaryView = DiaryView()
  private let titleContainerView = UIView().then {
    $0.layer.cornerRadius = 12
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor(red: 239, green: 239, blue: 239).cgColor
  }
  private let titleTextView = UITextView().then {
    $0.text = "제목"
    $0.font = .systemFont(ofSize: 12, weight: .semibold)
  }
  private let diaryTextContainerView = UIView().then {
    $0.layer.cornerRadius = 12
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor(red: 239, green: 239, blue: 239).cgColor
  }
  private let diaryTextView = UITextView().then {
    $0.text = "일기쓰기"
    $0.font = .systemFont(ofSize: 12, weight: .semibold)
  }
  private let doneButton = UIBarButtonItem().then {
    $0.title = "완료"
    $0.tintColor = .mainBlue
    $0.style = .done
    $0.setTitleTextAttributes(
      [.font: UIFont.systemFont(ofSize: 12, weight: .bold)],
      for: .normal
    )
    $0.isEnabled = false
  }

  init(diary: Group) {
    super.init()

    diaryView.rx.dataBinder.onNext(diary)
    textBinder()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }

  private func render() {
    view.add(scrollView)
    scrollView.add(diaryView)
    scrollView.add(titleContainerView)
    titleContainerView.add(titleTextView)
    scrollView.add(diaryTextContainerView)
    diaryTextContainerView.add(diaryTextView)
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
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
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.centerY.equalToSuperview()
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
    titleTextView.rx.didEndEditing
      .map { self.titleTextView.text }
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        if text == nil || text == "" {
          self.diaryTextView.text = "제목"
        }
      })
      .disposed(by: disposeBag)

    titleTextView.rx.didBeginEditing
      .map { self.titleTextView.text }
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        if text == "제목" {
          self.diaryTextView.text = ""
        }
      })
      .disposed(by: disposeBag)

    diaryTextView.rx.didEndEditing
      .map { self.diaryTextView.text }
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        if text == nil || text == "" {
          self.diaryTextView.text = "일기쓰기"
        }
      })
      .disposed(by: disposeBag)

    diaryTextView.rx.didBeginEditing
      .map { self.diaryTextView.text }
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        if text == "일기쓰기" {
          self.diaryTextView.text = ""
        }
      })
      .disposed(by: disposeBag)

    Observable.combineLatest(titleTextView.rx.text, diaryTextView.rx.text)
      .subscribe(onNext: { [weak self] title, diary in
        guard let self = self else { return }
        let canDone = title != "제목" && title != "" && diary != "일기쓰기" && diary != ""
        self.doneButton.isEnabled = canDone
      })
      .disposed(by: disposeBag)
  }

  private func bind() {

  }

}

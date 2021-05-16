//
//  InputView.swift
//  MARU
//
//  Created by 오준현 on 2021/05/02.
//

import UIKit

import Then
import RxSwift
import SnapKit

final class InputView: UIView {

  fileprivate let textView = UITextView().then {
    $0.font = UIFont.systemFont(ofSize: 16)
    $0.layer.cornerRadius = 10
  }

  fileprivate let sendButton = UIButton().then {
    $0.setImage(Image.chatBtnSend, for: .normal)
    $0.layer.cornerRadius = 6
  }

  let disposeBag = DisposeBag()

  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
    bindTextView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func bindTextView() {
    textView.rx.text.asDriver()
      .drive(onNext: { [weak self] text in
        guard let self = self, let text = text else { return }
        let detectSpaceBar = text.split(separator: " ").count
        self.sendButton.isEnabled = !text.isEmpty && detectSpaceBar != 0
      }).disposed(by: disposeBag)
  }
}

extension InputView {
  private func layout() {
    backgroundColor = .veryLightPinkThree
    add(sendButton) {
      $0.snp.makeConstraints {
        $0.width.height.equalTo(self.snp.height).offset(-2)
        $0.bottom.equalToSuperview().inset(2)
        $0.trailing.equalTo(self).offset(-2)
      }
    }
    add(textView) {
      $0.snp.makeConstraints {
        $0.top.equalToSuperview().inset(6)
        $0.leading.equalToSuperview().inset(10)
        $0.trailing.equalTo(self.sendButton.snp.leading).inset(4)
        $0.bottom.equalToSuperview().inset(6)
      }
    }
  }
}

extension InputView: UITextViewDelegate {}

extension Reactive where Base: InputView {
  var didTapSendButton: Observable<String> {
    return base.sendButton.rx.tap.map {
      guard let text = base.textView.text else { return "" }
      base.textView.text = nil
      return text
    }.asObservable()
  }
}

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

  private let contentView = UIView().then {
    $0.layer.cornerRadius = 37 / 2
    $0.layer.borderColor = UIColor.ligthGray.cgColor
    $0.layer.borderWidth = 1
  }

  fileprivate let sendButton = UIButton().then {
    $0.setImage(Image.chatBtnSend, for: .normal)
    $0.layer.cornerRadius = 6
  }

  private let disposeBag = DisposeBag()

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
      })
      .disposed(by: disposeBag)
  }
}

extension InputView {
  private func layout() {
    add(contentView) {
      $0.snp.makeConstraints {
        let inset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        $0.edges.equalToSuperview().inset(inset)
      }
    }
    contentView.add(sendButton) {
      $0.snp.makeConstraints {
        $0.width.height.equalTo(self.contentView.snp.height).offset(-2)
        $0.bottom.equalToSuperview().inset(2)
        $0.trailing.equalTo(self.contentView).offset(-2)
      }
    }
    contentView.add(textView) {
      $0.snp.makeConstraints {
        $0.top.equalToSuperview().inset(6)
        $0.leading.equalToSuperview().inset(8)
        $0.trailing.equalTo(self.sendButton.snp.leading).inset(4)
        $0.bottom.equalToSuperview().inset(6)
      }
    }
  }
}

extension InputView: UITextViewDelegate {}

extension Reactive where Base: InputView {
  var didTapSendButton: Observable<String> {
    return base.sendButton.rx.tap
      .map {
        guard let text = base.textView.text else { return "" }
        base.textView.text = nil
        return text
      }
  }
}

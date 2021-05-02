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
  }
  fileprivate let sendButton = UIButton().then {
    $0.setImage(Image.blueO, for: .normal)
    $0.layer.cornerRadius = 6
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension InputView {
  private func layout() {
    add(textView) {
      $0.snp.makeConstraints {
        $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 30))
      }
    }
    add(sendButton) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.textView.snp.trailing).offset(4)
        $0.top.bottom.equalTo(self.textView)
        $0.trailing.equalTo(self).offset(4)
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

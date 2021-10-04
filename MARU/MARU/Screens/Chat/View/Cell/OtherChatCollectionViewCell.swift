//
//  OtherChatCollectionViewCell.swift
//  MARU
//
//  Created by 오준현 on 2021/05/05.
//

import UIKit

import RxCocoa
import RxSwift

final class OtherChatCollectionViewCell: UICollectionViewCell {

  override var isHighlighted: Bool {
    didSet {
      chatBubbleView.backgroundColor = isHighlighted ? .black.withAlphaComponent(0.02) : .white
    }
  }

  private let chatLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.numberOfLines = 0
  }

  fileprivate let chatBubbleView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 16
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.ligthGray.cgColor
  }

  fileprivate var data: RealmChat = RealmChat() {
    didSet {
      chatLabel.text = data.content
    }
  }

  var disposeBag = DisposeBag()

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    bind()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  private func render() {
    contentView.add(chatBubbleView)
    contentView.add(chatLabel) { label in
      label.snp.makeConstraints {
        $0.top.equalToSuperview().offset(9)
        $0.leading.equalToSuperview().offset(66)
        $0.trailing.lessThanOrEqualTo(self.contentView).inset(60)
      }
    }
    chatBubbleView.snp.makeConstraints {
      let inset = UIEdgeInsets(top: -9, left: -11, bottom: -9, right: -11)
      $0.edges.equalTo(chatLabel).inset(inset)
    }
  }

  private func bind() {

  }

}

extension Reactive where Base: OtherChatCollectionViewCell {
  var dataBinder: Binder<RealmChat> {
    return Binder(base) { base, data in
      base.data = data
    }
  }

  var didLongTapBubble: Observable<Void> {
    return base.chatBubbleView.rx.longPressGesture()
      .when(.recognized)
      .map { _ in }
  }
}

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

  private let chatLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.numberOfLines = 0
  }

  private let chatBubbleView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 16
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.ligthGray.cgColor
  }

  fileprivate var data: ChatDTO = .init(profileImage: nil, name: nil, message: nil) {
    didSet {
      chatLabel.text = data.message
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
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

}

extension Reactive where Base: OtherChatCollectionViewCell {
  var dataBinder: Binder<ChatDTO> {
    return Binder(base) { base, data in
      base.data = data
    }
  }
}

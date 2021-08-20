//
//  MyChatCell.swift
//  MARU
//
//  Created by 오준현 on 2021/05/05.
//

import UIKit

import RxCocoa
import RxSwift

final class MyChatCollectionViewCell: UICollectionViewCell {

  private let nameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.numberOfLines = 0
  }

  private let chatLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.numberOfLines = 0
  }

  private let chatBubbleView = UIView().then {
    $0.backgroundColor = .ligthGray
    $0.layer.cornerRadius = 16
  }

  fileprivate var data: ChatDTO = .init(profileImage: nil, name: nil, message: nil) {
    didSet {
      chatLabel.text = data.message
      chatLabel.sizeToFit()
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
        $0.top.equalToSuperview().inset(9)
        $0.trailing.equalToSuperview().inset(34)
        $0.width.lessThanOrEqualToSuperview().inset(50)
      }
    }
    chatBubbleView.snp.makeConstraints {
      let inset = UIEdgeInsets(top: -9, left: -11, bottom: -9, right: -11)
      $0.edges.equalTo(chatLabel).inset(inset)
    }
  }
}

extension Reactive where Base: MyChatCollectionViewCell {
  var dataBinder: Binder<ChatDTO> {
    return Binder(base) { base, data in
      base.data = data
    }
  }
}

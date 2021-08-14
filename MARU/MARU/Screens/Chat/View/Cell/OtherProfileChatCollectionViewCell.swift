//
//  OtherProfileChatCollectionViewCell.swift
//  MARU
//
//  Created by 오준현 on 2021/08/15.
//

import UIKit

import RxCocoa
import RxSwift

final class OtherProfileChatCollectionViewCell: UICollectionViewCell {

  private let profileImageView = UIImageView().then {
    $0.backgroundColor = .red.withAlphaComponent(0.1)
    $0.layer.cornerRadius = 15
  }

  private let nameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.numberOfLines = 0
  }

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

  fileprivate var data: ChatDAO = .init(profileImage: nil, name: nil, message: nil) {
    didSet {
      nameLabel.text = "안유댕"
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
    contentView.add(profileImageView) { view in
      view.snp.makeConstraints {
        $0.top.equalToSuperview()
        $0.leading.equalToSuperview().offset(20)
        $0.size.equalTo(30)
      }
    }
    contentView.add(nameLabel) { label in
      label.snp.makeConstraints {
        $0.top.equalToSuperview()
        $0.leading.equalTo(self.profileImageView.snp.trailing).offset(4)
      }
    }
    contentView.add(chatBubbleView)
    contentView.add(chatLabel) { label in
      label.snp.makeConstraints {
        $0.top.equalTo(self.nameLabel.snp.bottom).offset(14)
        $0.leading.equalTo(self.profileImageView.snp.trailing).offset(16)
        $0.trailing.lessThanOrEqualTo(self.contentView).inset(30)
      }
    }
    chatBubbleView.snp.makeConstraints {
      let inset = UIEdgeInsets(top: -9, left: -11, bottom: -9, right: -11)
      $0.edges.equalTo(chatLabel).inset(inset)
    }
  }
}

extension Reactive where Base: OtherProfileChatCollectionViewCell {
  var dataBinder: Binder<ChatDAO> {
    return Binder(base) { base, data in
      base.data = data
    }
  }
}

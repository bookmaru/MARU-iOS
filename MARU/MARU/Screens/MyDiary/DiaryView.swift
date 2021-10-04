//
//  DiaryView.swift
//  MARU
//
//  Created by 오준현 on 2021/09/27.
//

import UIKit

import RxCocoa
import RxSwift

final class DiaryView: UIView {

  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
  }

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 11, weight: .semibold)
  }

  private let authorLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 10, weight: .semibold)
  }

  private let contentContainerView = UIView()

  private let leftQuotationImageView = UIImageView(image: Image.quotationMarkLeft)

  private let rightQuotationImageView = UIImageView(image: Image.quotationMarkRight)

  private let contentLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 10, weight: .semibold)
    $0.textColor = .brownGrey
  }

  private let ownerLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 10, weight: .semibold)
    $0.textColor = .brownGrey
  }

  fileprivate var data: Group? {
    didSet {
      guard let data = data else { return }
      titleLabel.text = data.title
      authorLabel.text = data.author
      contentLabel.text = data.description
      ownerLabel.text = "By \(data.nickname)"
      imageView.imageFromUrl(data.image, defaultImgPath: "")
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {
    layer.cornerRadius = 5
    layer.masksToBounds = true
    add(imageView)
    add(titleLabel)
    add(authorLabel)
    add(contentContainerView)
    contentContainerView.add(contentLabel)
    contentContainerView.add(leftQuotationImageView)
    contentContainerView.add(rightQuotationImageView)
    add(ownerLabel)
    imageView.snp.makeConstraints {
      $0.leading.top.bottom.equalToSuperview()
      $0.width.equalTo(96)
    }
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(imageView.snp.trailing).offset(12)
      $0.top.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-65)
    }
    authorLabel.snp.makeConstraints {
      $0.leading.equalTo(titleLabel)
      $0.top.equalTo(titleLabel.snp.bottom).offset(3)
    }
    contentContainerView.snp.makeConstraints {
      let inset = UIEdgeInsets(top: 50, left: 109, bottom: 31, right: 13)
      $0.edges.equalToSuperview().inset(inset)
    }
    contentLabel.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    leftQuotationImageView.snp.makeConstraints {
      $0.leading.top.equalToSuperview()
      $0.width.equalTo(9.3)
      $0.height.equalTo(8.1)
    }
    rightQuotationImageView.snp.makeConstraints {
      $0.trailing.bottom.equalToSuperview()
      $0.width.equalTo(9.3)
      $0.height.equalTo(8.1)
    }
    ownerLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-10)
      $0.bottom.trailing.equalToSuperview().offset(-13)
    }
    backgroundColor = .white
    applyShadow(color: .black, alpha: 0.1, shadowX: 0, shadowY: 1, blur: 15)
  }

}

extension Reactive where Base: DiaryView {
  var dataBinder: Binder<Group> {
    return Binder(base) { base, group in
      base.data = group
    }
  }
}

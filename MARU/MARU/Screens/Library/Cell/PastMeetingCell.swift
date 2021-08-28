//
//  PastMeetingCell.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/29.
//

import UIKit
import RxCocoa
import RxSwift

final class PastMeetingCell: UICollectionViewCell {
  
  
  fileprivate let shadowView = UIView().then {
    $0.backgroundColor = .white
    $0.applyShadow(color: .black, alpha: 0.15, shadowX: 0, shadowY: 2, blur: 5/2)
    $0.layer.cornerRadius = 5
  }
  fileprivate let bookTitleLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    $0.text = "책 제목"
  }
  fileprivate let bookAuthorLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 10, weight: .medium)
    $0.text = "저자라벨"
  }
  fileprivate var bookImageView = UIImageView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 5
    $0.image = Image.union
  }
  fileprivate var meetingLeaderLabel = UILabel().then {
    $0.text = "방장 이름"
    $0.textColor = .brownishGrey // 수정 필.
    $0.textAlignment = .right
    $0.font = .systemFont(ofSize: 10, weight: .bold)
  }
  fileprivate let explainBox = UILabel().then {
    $0.backgroundColor = .white
  }
  fileprivate let explanationLabel = UILabel().then {
    $0.text = "책에 대해서 blahblah"
    $0.textAlignment = .center
    $0.textColor = UIColor.black
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.numberOfLines = 3
  }
  fileprivate let leftQuotataionImageView = UIImageView().then {
    $0.image = Image.blueQuotationleft
  }
  fileprivate let rightQuotataionImageView = UIImageView().then {
    $0.image = Image.blueQuotationRight
  }
  let evaluateButton = UIButton().then {
    $0.setImage(Image.invalidName, for: .normal)
    $0.isHidden = true
  }
  var disposeBag = DisposeBag()
  fileprivate var data: KeepGroup? {
    didSet {
      bookTitleLabel.text = data?.title
      // 추가로 데이터 더 할당해주어야함!
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
    disposeBag = DisposeBag()
  }
  private func render() {
    contentView.add(shadowView)
    shadowView.adds([
      explainBox,
      bookTitleLabel,
      bookAuthorLabel,
      bookImageView,
      meetingLeaderLabel,
    ])
    explainBox.adds([
      explanationLabel,
      leftQuotataionImageView,
      rightQuotataionImageView
    ])
    
    shadowView.snp.makeConstraints { view in
      view.top.equalTo(contentView.snp.top).offset(2)
      view.leading.equalTo(contentView).offset(2)
      view.trailing.equalTo(contentView).offset(-2)
      view.bottom.equalTo(contentView.snp.bottom).offset(-2)
    }
    bookImageView.snp.makeConstraints { image in
      image.top.equalTo(shadowView.snp.top).offset(0)
      image.leading.equalTo(shadowView.snp.leading).offset(0)
      image.bottom.equalTo(shadowView.snp.bottom).offset(0)
      image.width.equalTo(96)
    }
    bookTitleLabel.snp.makeConstraints { label in
      label.top.equalTo(shadowView.snp.top).offset(10)
      label.leading.equalTo(bookImageView.snp.trailing).offset(12)
    }
    bookAuthorLabel.snp.makeConstraints { label in
      label.top.equalTo(bookTitleLabel.snp.bottom).offset(3)
      label.leading.equalTo(bookTitleLabel.snp.leading)
    }
    meetingLeaderLabel.snp.makeConstraints { label in
      label.top.equalTo(shadowView.snp.top).offset(8)
      label.trailing.equalTo(shadowView.snp.trailing).offset(-10)
    }
    explainBox.snp.makeConstraints { view in
      view.top.equalTo(bookAuthorLabel.snp.bottom).offset(11)
      view.leading.equalTo(bookImageView.snp.trailing).offset(3)
      view.trailing.equalTo(shadowView.snp.trailing).offset(-10)
      view.height.equalTo(50)
    }
    leftQuotataionImageView.snp.makeConstraints { image in
      image.top.equalTo(explainBox.snp.top).offset(0)
      image.leading.equalTo(explainBox.snp.leading).offset(0)
      image.size.equalTo(8)
    }
    rightQuotataionImageView.snp.makeConstraints { image in
      image.trailing.equalTo(explainBox.snp.trailing).offset(0)
      image.bottom.equalTo(explainBox.snp.bottom).offset(0)
      image.size.equalTo(8)
    }
    explanationLabel.snp.makeConstraints { label in
      label.top.equalTo(explainBox.snp.top).offset(3)
      label.leading.equalTo(leftQuotataionImageView.snp.trailing).offset(23)
      label.trailing.equalTo(rightQuotataionImageView.snp.leading).offset(23)
    }
  }
}

extension Reactive where Base: PastMeetingCell {
  var didTapEvaluateButton: Observable<Void> {
    return base.evaluateButton.rx.tap
      .map { return }
      .asObservable()
  }
}

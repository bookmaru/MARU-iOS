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
  private let shadowView = UIView().then {
    $0.backgroundColor = .white
    $0.applyShadow(color: .black, alpha: 0.15, shadowX: 0, shadowY: 2, blur: 5/2)
    $0.layer.cornerRadius = 5
  }
  private let bookTitleLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    $0.text = "책 제목"
  }
  private let bookAuthorLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
    $0.text = "저자라벨"
    $0.textColor = .subText
  }
  private var bookImageView = UIImageView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 5
    $0.image = Image.gradientImage
  }
  private var meetingLeaderLabel = UILabel().then {
    $0.text = "방장 이름"
    $0.textColor = .brownishGrey // 수정 필.
    $0.textAlignment = .right
    $0.font = .systemFont(ofSize: 10, weight: .semibold)
  }
  private let explanationLabel = UILabel().then {
    $0.text = """
    식물책표지가되게예쁘네네네네네네
    무슨내용일까까까가가가가가가가가
    와랄랄라와랄랄라와랄랄라와랄라라
    """
    $0.textAlignment = .center
    $0.textColor = UIColor.black
    $0.font = .systemFont(ofSize: 12, weight: .regular)
    $0.numberOfLines = 3
  }
  private let leftQuotataionImageView = UIImageView().then {
    $0.image = Image.quotationMarkLeft
  }
  private let rightQuotataionImageView = UIImageView().then {
    $0.image = Image.quotationMarkRight
  }
  let evaluateButton = UIButton().then {
    $0.setImage(Image.invalidName, for: .normal)
    $0.isHidden = true
  }
  var disposeBag = DisposeBag()
  fileprivate var data: KeepGroup? {
    didSet {
      bookTitleLabel.text = data?.title
      bookAuthorLabel.text = data?.author
      // TODO: - 이미지 전달 변경하기
      bookImageView.image = UIImage(named: data?.image ?? "group1015")
      // id 정보 전달 방안 생각하기
      explanationLabel.text = data?.description
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
      bookTitleLabel,
      bookAuthorLabel,
      bookImageView,
      meetingLeaderLabel,
      explanationLabel,
      leftQuotataionImageView,
      rightQuotataionImageView,
      evaluateButton
    ])
    shadowView.snp.makeConstraints { make in
      make.top.equalTo(contentView).offset(3)
      make.leading.equalTo(contentView).offset(3)
      make.trailing.equalTo(contentView).offset(-3)
      make.bottom.equalTo(contentView).offset(-10)
    }
    bookImageView.snp.makeConstraints { make in
      make.top.equalTo(shadowView.snp.top)
      make.leading.equalTo(shadowView.snp.leading)
      make.bottom.equalTo(shadowView.snp.bottom)
      make.width.equalTo(96)
    }
    bookTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(shadowView).offset(10)
      make.leading.equalTo(bookImageView.snp.trailing).offset(12)
      make.height.equalTo(16)
    }
    bookAuthorLabel.snp.makeConstraints { make in
      make.top.equalTo(bookTitleLabel.snp.bottom).offset(1)
      make.leading.equalTo(bookTitleLabel.snp.leading)
      make.height.equalTo(13)
    }
    meetingLeaderLabel.snp.makeConstraints { make in
      make.top.equalTo(shadowView).offset(8)
      make.trailing.equalTo(shadowView).offset(-10)
      make.height.equalTo(13)
    }

    leftQuotataionImageView.snp.makeConstraints { make in
      make.top.equalTo(bookAuthorLabel.snp.bottom).offset(6)
      make.leading.equalTo(bookAuthorLabel.snp.leading)
      make.size.equalTo(8)
    }
    rightQuotataionImageView.snp.makeConstraints { make in
      make.trailing.equalTo(shadowView).offset(-10)
      make.top.equalTo(shadowView).offset(90)
      make.size.equalTo(8)
    }
    explanationLabel.snp.makeConstraints { make in
      make.top.equalTo(bookAuthorLabel.snp.bottom).offset(7)
      make.leading.equalTo(leftQuotataionImageView.snp.trailing).offset(15)
      make.width.equalTo(175)
    }
    evaluateButton.snp.makeConstraints { make in
      make.trailing.equalTo(rightQuotataionImageView.snp.trailing)
      make.top.equalTo(rightQuotataionImageView.snp.bottom).offset(6)
      make.width.equalTo(68)
    }
  }
}

extension Reactive where Base: PastMeetingCell {
  var didTapEvaluateButton: Observable<Void> {
    return base.evaluateButton.rx.tap
      .map { return }
      .asObservable()
  }
  var dataBinder: Binder<KeepGroup?> {
    return Binder(base) { base, data in
      base.data = data
    }
  }
}

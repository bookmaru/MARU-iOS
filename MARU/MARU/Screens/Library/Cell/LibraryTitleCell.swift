//
//  LibraryTitleCell.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import UIKit

import Then
import RxSwift
import RxCocoa

final class LibraryTitleCell: UICollectionViewCell {
  private let sectionLabelView = UIView().then {
    $0.backgroundColor = .black
  }
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17, weight: .bold)
  }

  let addButton = UIButton().then {
    $0.setImage(Image.group874, for: .normal)
    $0.isHidden = true
  }
  fileprivate var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  var disposeBag = DisposeBag()
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
    contentView.add(sectionLabelView) { sectionView in
      sectionView.snp.makeConstraints {
        $0.width.equalTo(20)
        $0.height.equalTo(3)
        $0.top.equalToSuperview().offset(25)
        $0.leading.equalToSuperview().offset(15)
      }
    }
    contentView.add(titleLabel) { label in
      label.snp.makeConstraints {
        $0.leading.equalToSuperview().offset(30)
        $0.top.equalTo(self.sectionLabelView.snp.bottom).offset(9)
      }
    }
    contentView.add(addButton) { button in
      button.snp.makeConstraints {
        $0.trailing.equalToSuperview().offset(-20)
        $0.centerY.equalTo(self.titleLabel)
        $0.size.equalTo(40)
      }
    }
  }
}

extension Reactive where Base: LibraryTitleCell {
  var didTapAddButton: Observable<String> {
    return base.addButton.rx.tap
      .map { return base.title ?? "" }
      .asObservable()
  }

  var addButtonIsHiddenBinder: Binder<Bool> {
    return Binder(base) { base, isHiddenButton in
      base.addButton.isHidden = isHiddenButton
    }
  }

  var titleBinder: Binder<String> {
    return Binder(base) { base, title in
      base.title = title
    }
  }
}

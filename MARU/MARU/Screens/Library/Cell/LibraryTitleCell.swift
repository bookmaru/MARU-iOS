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

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17, weight: .bold)
  }

  fileprivate let addButton = UIButton().then {
    $0.setImage(Image.correct, for: .normal)
    $0.isHidden = true
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {
    contentView.add(titleLabel) { label in
      label.snp.makeConstraints {
        $0.leading.equalToSuperview().offset(20)
        $0.top.equalToSuperview().offset(20)
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
  var didTapAddButton: Observable<Void> {
    return base.addButton.rx.tap
      .map { return }
      .asObservable()
  }

  var addButtonIsHiddenBinder: Binder<Bool> {
    return Binder(base) { base, isHiddenButton in
      base.addButton.isHidden = isHiddenButton
    }
  }
}

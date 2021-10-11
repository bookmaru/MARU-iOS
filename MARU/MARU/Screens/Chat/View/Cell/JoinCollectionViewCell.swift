//
//  JoinCollectionViewCell.swift
//  MARU
//
//  Created by 오준현 on 2021/10/11.
//

import UIKit

import RxCocoa
import RxSwift

final class JoinCollectionViewCell: UICollectionViewCell {

  fileprivate var group: GeneratedGroup?

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension Reactive where Base: JoinCollectionViewCell {
  var dataBinder: Binder<GeneratedGroup> {
    return Binder(base) { base, group in
      base.group = group
    }
  }
}

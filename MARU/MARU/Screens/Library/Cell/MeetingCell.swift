//
//  MeetingCell.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import UIKit
import RxCocoa
import RxSwift

final class MeetingCell: UICollectionViewCell {

  fileprivate let imageView = UIImageView().then {
    $0.layer.cornerRadius = 5
    $0.layer.masksToBounds = true
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
    contentView.add(imageView) { view in
      view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
  }
}

extension Reactive where Base: MeetingCell {
  var binder: Binder<String> {
    return Binder(base) { base, string in
      base.imageView.setImage(from: string, UIImage())
    }
  }
}

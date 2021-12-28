//
//  MyLibraryBookCell.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/22.
//

import UIKit
import RxCocoa
import RxSwift

final class MyLibraryBookCell: UICollectionViewCell {
  fileprivate let imageView = UIImageView().then {
    $0.layer.cornerRadius = 5
    $0.layer.masksToBounds = true
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  var disposeBag = DisposeBag()
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

extension Reactive where Base: MyLibraryBookCell {
  var imageURLBinder: Binder<String> {
    return Binder(base) { base, imageURL in
      base.imageView.image(
        url: imageURL,
        defaultImage: Image.defalutImage ?? UIImage()
      )
    }
  }
}

//
//  BookFavoritesCell.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/19.
//

import UIKit
import RxCocoa
import RxSwift

final class BookFavoritesCell: UICollectionViewCell {
  private let bookImageView = UIImageView().then {
    $0.layer.cornerRadius = 5
    $0.image = Image.image120
  }
  
  private let bookTitleLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    $0.text = "책 제목"
  }
  
  private let bookAuthorLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    $0.textColor = .subText
  }
  
  var disposeBag = DisposeBag()
  
  fileprivate var data: BookCase? {
    didSet {
      bookTitleLabel.text = data?.title
      bookAuthorLabel.text = data?.author
      bookImageView.imageFromUrl(data?.imageURL, defaultImgPath: "")
      bookImageView.image = UIImage(named: data?.imageURL ?? "group1015")
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
    contentView.adds([
      bookImageView,
      bookTitleLabel,
      bookAuthorLabel
    ])
    
    bookImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(0)
      make.leading.equalToSuperview().offset(0)
      make.trailing.equalToSuperview().offset(0)
    }
    
    bookTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(bookImageView.snp.bottom).offset(5)
      make.leading.equalTo(bookImageView.snp.leading)
      make.height.equalTo(15)
    }
    
    bookAuthorLabel.snp.makeConstraints { make in
      make.top.equalTo(bookTitleLabel.snp.bottom).offset(1)
      make.leading.equalTo(bookTitleLabel.snp.leading)
      make.height.equalTo(15)
    }
  }
}

extension Reactive where Base: BookFavoritesCell {
  var dataBinder: Binder<BookCase?> {
    return Binder(base) { base, data in
      base.data = data
    }
  }
}

//
//  BookFavoritesShelfCell.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/19.
//

import UIKit
import RxCocoa
import RxSwift

final class BookFavoritesShelfCell: UICollectionViewCell {
  private let shelfImageView = UIImageView().then {
    $0.image = Image.vector21
  }
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = UIColor.clear
    collectionView.register(cell: BookFavoritesCell.self, forCellWithReuseIdentifier: BookFavoritesCell.reuseIdentifier)
    return collectionView
  }()
  fileprivate var bookData: BookCaseModel? {
    didSet {
      collectionView.reloadData()
    }
  }
  var disposeBag = DisposeBag()
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  private func render() {
    contentView.add(shelfImageView)
    contentView.add(collectionView)
    shelfImageView.snp.makeConstraints { make in
      make.height.equalTo(80)
      make.leading.equalTo(contentView).offset(0)
      make.trailing.equalTo(contentView).offset(0)
      make.bottom.equalTo(contentView).offset(0)
    }
    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

extension Reactive where Base: BookFavoritesShelfCell {
  var binder: Binder<BookCaseModel> {
    return Binder(base) { base, data in
      base.bookData = data
    }
  }
}

extension BookFavoritesShelfCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 87, height: 170)
  }
}

extension BookFavoritesShelfCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
  -> UICollectionViewCell {
    let cell: BookFavoritesCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.rx.dataBinder.onNext((bookData?.bookcase[indexPath.item]))
    return cell
  }
}

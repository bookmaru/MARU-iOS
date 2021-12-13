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
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 14, left: 40, bottom: 14, right: 40)
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(cell: BookFavoritesCell.self, forCellWithReuseIdentifier: BookFavoritesCell.reuseIdentifier)
    return collectionView
  }()

  fileprivate var bookData: [BookCase] = [] {
    didSet {
      collectionView.reloadData()
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
    contentView.add(collectionView)
    collectionView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(12)
      make.trailing.equalToSuperview().offset(-12)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

extension BookFavoritesShelfCell: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: 87, height: 100)
  }
}
extension BookFavoritesShelfCell: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return bookData.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: BookFavoritesCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.rx.dataBinder.onNext((bookData[indexPath.item]))
    return cell
  }
}

extension Reactive where Base: BookFavoritesShelfCell {
  var binder: Binder<[BookCase]> {
    return Binder(base) { base, data in
      base.bookData = data
    }
  }

  var didTapContentView: Observable<Void> {
    return base.contentView.rx.tapGesture()
      .when(.recognized)
      .map { _ in return }
      .asObservable()
  }
}

//
//  MyBookCaseCell.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/22.
//

import UIKit
import RxSwift
import RxCocoa

final class MyBookCaseCell: UICollectionViewCell {

  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 14, left: 40, bottom: 14, right: 40)
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 10
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cell: MyLibraryBookCell.self, forCellWithReuseIdentifier: MyLibraryBookCell.reuseIdentifier)
    collectionView.backgroundColor = .white
    return collectionView
  }()

  let noResultImageView = UIImageView().then {
    $0.backgroundColor = .white
    $0.image = Image.vector21
    $0.isHidden = true
  }

  let bookImage = UIImageView().then {
    $0.image = Image.autoStories
  }

  let emptyLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = .subText
    $0.textAlignment = .center
    $0.text = "서재를 채워주세요 :)"
  }

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
    contentView.add(collectionView) { view in
      view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    collectionView.add(noResultImageView) { imageView in
      imageView.snp.makeConstraints {
        $0.edges.equalTo(self.contentView)
      }
    }
    noResultImageView.add(bookImage) { image in
      image.snp.makeConstraints {
        $0.size.equalTo(16)
        $0.centerX.equalTo(self.noResultImageView)
        $0.top.equalTo(self.noResultImageView).offset(20)
      }
    }
    noResultImageView.add(emptyLabel) { label in
      label.snp.makeConstraints {
        $0.centerX.equalTo(self.noResultImageView)
        $0.top.equalTo(self.bookImage.snp.bottom).offset(4)
      }
    }
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

extension MyBookCaseCell: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: (ScreenSize.width - 80 - 40) / 4, height: 106)
  }
}

extension MyBookCaseCell: UICollectionViewDataSource {
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
    let cell: MyLibraryBookCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

    cell.rx.imageURLBinder.onNext(bookData[indexPath.item].imageURL)

    return cell
  }
}
extension Reactive where Base: MyBookCaseCell {
  var binder: Binder<[BookCase]> {
    return Binder(base) { base, data in
      base.bookData = data
    }
  }
}

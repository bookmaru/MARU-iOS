//
//  MyLibraryCell.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import UIKit
import RxSwift
import RxCocoa

final class MyLibraryCell: UICollectionViewCell {

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 30)
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 10
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cell: MeetingCell.self, forCellWithReuseIdentifier: MeetingCell.reuseIdentifier)
    collectionView.backgroundColor = .white
    return collectionView
  }()

  let noResultImageView = UIImageView().then {
    $0.backgroundColor = .none
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

  fileprivate var groupData: [KeepGroup] = [] {
    didSet {
      collectionView.reloadData()
    }
  }

  var disposeBag = DisposeBag()

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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

extension MyLibraryCell: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: (ScreenSize.width - 60 - 30) / 4, height: 106)
  }
}

extension MyLibraryCell: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return groupData.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: MeetingCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

    cell.rx.imageURLBinder.onNext(groupData[indexPath.item].image)

    return cell
  }
}

extension Reactive where Base: MyLibraryCell {
  var binder: Binder<[KeepGroup]> {
    return Binder(base) { base, data in
      base.groupData = data
    }
  }
}

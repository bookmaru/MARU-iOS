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
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    return collectionView
  }()
  
  fileprivate var bookData: BookCase? {
    didSet {
      collectionView.reloadData()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
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
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}
extension MyBookCaseCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 30, height: 70)
  }
}
extension MyBookCaseCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 4
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: MyLibraryBookCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.rx.binder.onNext(bookData?.imageUrl ?? "")
    return cell
  }
}
extension Reactive where Base: MyBookCaseCell {
  var binder: Binder<BookCase> {
    return Binder(base) { base, data in
      base.bookData = data
    }
  }
}

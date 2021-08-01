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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()
  fileprivate var data: [String] = [] {
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

extension MyLibraryCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 30, height: 70)
  }
}
extension MyLibraryCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: MeetingCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.rx.binder.onNext(data[indexPath.item])
    return cell
  }
}

extension Reactive where Base: MyLibraryCell {
  var binder: Binder<[String]> {
    return Binder(base) { base, data in
      base.data = data
    }
  }
}

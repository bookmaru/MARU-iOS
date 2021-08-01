//
//  MyLibraryViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/01.
//

import UIKit
import SnapKit

final class MyLibraryViewController: UIViewController {
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()

  private var data: [Library] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }

  private func render() {
    view.add(collectionView) { view in
      view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

extension MyLibraryViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return data.count
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data[section].count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch data[indexPath.section] {
    case let .title(titleText, isHidden):
      let cell: LibraryTitleCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.rx.didTapAddButton
        .subscribe(onNext: {
        
        }).disposed(by: cell.disposeBag)
      cell.rx.addButtonIsHiddenBinder.onNext(isHidden)
      cell.rx.titleBinder.onNext(titleText)
      return cell
    case let .meeting(data):
      let cell: MyLibraryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.rx.binder.onNext(data)
      return cell
    case let .diary(data):
      let cell: LibraryDiaryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.rx.didTapContentView
        .subscribe(onNext: {
        
      }).disposed(by: cell.disposeBag)
      cell.rx.dataBinder.onNext(data[indexPath.item])
      return cell
    }
  }
}

extension MyLibraryViewController: UICollectionViewDelegateFlowLayout {

}

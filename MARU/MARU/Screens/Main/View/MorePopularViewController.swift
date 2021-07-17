//
//  MorePopularViewController.swift
//  MARU
//
//  Created by psychehose on 2021/06/30.
//

import UIKit

class MorePopularViewController: BaseViewController {

  enum Section {
    case main
  }

  private var collectionView: UICollectionView! = nil
  private var dataSource: UICollectionViewDiffableDataSource<Section, BookModel>! = nil
  private var initData = BookModel.initMainData
  override func viewDidLoad() {
    super.viewDidLoad()
    configureHierarchy()
    configureDataSource()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: false)
    navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    navigationController?.navigationBar.barTintColor = .white
  }
}

extension MorePopularViewController {
  /// - TAG: Layout
  private func configureHierarchy() {
    collectionView = UICollectionView(frame: .zero,
                                      collectionViewLayout: MaruListCollectionViewLayout.createLayout())
    view.add(collectionView) {
      $0.snp.makeConstraints { make in
        make.top.equalToSuperview().inset(15)
        make.bottom.equalToSuperview()
        make.leading.equalToSuperview()
        make.trailing.equalToSuperview()
      }
    }

    collectionView.backgroundColor = .clear
    collectionView.delegate = self
  }

  private func configureDataSource() {
    let cellRegistration = UICollectionView
      .CellRegistration<MeetingListCell, BookModel> {_, _, _ in
      }

    dataSource = UICollectionViewDiffableDataSource<Section, BookModel>(
    collectionView: collectionView,
      cellProvider: { collectionView, indexPath, libraryBook in
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                            for: indexPath,
                                                            item: libraryBook)
      })

    var snapshot = NSDiffableDataSourceSnapshot<Section, BookModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(initData)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
extension MorePopularViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard dataSource.itemIdentifier(for: indexPath) != nil else {
      return
    }
  }
}

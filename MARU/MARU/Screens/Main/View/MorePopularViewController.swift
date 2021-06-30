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

  let screenSize = UIScreen.main.bounds.size

  private var collectionView: UICollectionView! = nil
  private var dataSource: UICollectionViewDiffableDataSource<Section, LibraryBook>! = nil
  private var initData = LibraryBook.initData
  override func viewDidLoad() {
    super.viewDidLoad()
    configureHierarchy()
    configureDataSource()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: false)
  }
}
extension MorePopularViewController {
  /// - TAG: Layout
  private func configureHierarchy() {
    collectionView = UICollectionView(frame: .zero,
                                      collectionViewLayout: MaruListCollectionViewLayout.createLayout())
    view.add(collectionView) {
      $0.snp.makeConstraints { make in
        make.top.equalToSuperview()
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
      .CellRegistration<WasDebateCell, LibraryBook> {_, _, _ in

      }

    dataSource = UICollectionViewDiffableDataSource<Section, LibraryBook>(
    collectionView: collectionView,
      cellProvider: { collectionView, indexPath, libraryBook in
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                            for: indexPath,
                                                            item: libraryBook)
      })

    var snapshot = NSDiffableDataSourceSnapshot<Section, LibraryBook>()
    snapshot.appendSections([.main])
    snapshot.appendItems(initData)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
extension MorePopularViewController: UICollectionViewDelegate {
}

//
//  MoreWasDebateViewController.swift
//  MARU
//
//  Created by psychehose on 2021/06/28.
//

import UIKit

final class MoreWasDebateViewController: BaseViewController {
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
}
extension MoreWasDebateViewController {
  /// - TAG: collectionView layout
  private func createLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(screenSize.width * 0.895),
                                           heightDimension: .absolute(142))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: .fixed(23))

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                    leading: 20,
                                                    bottom: 0,
                                                    trailing: 20)
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
}

extension MoreWasDebateViewController {
  private func configureHierarchy() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

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

extension MoreWasDebateViewController: UICollectionViewDelegate {
}

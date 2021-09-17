//
//  MoreWasDebateViewController.swift
//  MARU
//
//  Created by psychehose on 2021/06/28.
//

import UIKit

final class MeetingHeldViewController: BaseViewController {
  enum Section {
    case main
  }

  let screenSize = UIScreen.main.bounds.size

  private var collectionView: UICollectionView! = nil
  private var dataSource: UICollectionViewDiffableDataSource<Section, LibraryModel>! = nil
  private var initData = LibraryModel.initData

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

extension MeetingHeldViewController {
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
      .CellRegistration<WasDebateCell, LibraryModel> {cell, indexPath, _ in
        cell.buttonDelegate = self
        cell.setupButtonTag(itemNumber: indexPath.item)
      }

    dataSource = UICollectionViewDiffableDataSource<Section, LibraryModel>(
    collectionView: collectionView,
      cellProvider: { collectionView, indexPath, libraryBook in
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                            for: indexPath,
                                                            item: libraryBook)
      })

    var snapshot = NSDiffableDataSourceSnapshot<Section, LibraryModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(initData)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

extension MeetingHeldViewController: UICollectionViewDelegate {
}

extension MeetingHeldViewController: ButtonDelegate {
  func didPressButtonInHeader(_ tag: Int) {
    print("\(tag)")
  }
}

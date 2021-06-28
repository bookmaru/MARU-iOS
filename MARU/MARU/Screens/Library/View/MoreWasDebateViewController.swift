//
//  MoreWasDebateViewController.swift
//  MARU
//
//  Created by psychehose on 2021/06/28.
//

import UIKit

class MoreWasDebateViewController: BaseViewController {
  enum Section {
    case main
  }

  let screenSize = UIScreen.main.bounds.size

  private var collectionView: UICollectionView! = nil
  private var dataSource: UICollectionViewDiffableDataSource<Section, LibraryBook>! = nil
  override func viewDidLoad() {
    super.viewDidLoad()
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
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(collectionView)
    collectionView.delegate = self
  }
  
}

extension MoreWasDebateViewController: UICollectionViewDelegate {
  
}

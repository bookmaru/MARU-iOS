//
//  MaruListCollectionViewLayout.swift
//  MARU
//
//  Created by psychehose on 2021/06/30.
//

import UIKit

final class MaruListCollectionViewLayout: NSObject {

  static let screenSize = UIScreen.main.bounds

  static func createLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(screenSize.width * 0.895),
                                           heightDimension: .absolute(142))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: .fixed(15))

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 15,
                                                    leading: 20,
                                                    bottom: 0,
                                                    trailing: 20)
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
  static func createSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(screenSize.width * 0.895),
                                           heightDimension: .absolute(142))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: .fixed(15))

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                    leading: 20,
                                                    bottom: 0,
                                                    trailing: 20)
    return section
  }
}

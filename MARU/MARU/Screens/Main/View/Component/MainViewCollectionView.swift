//
//  MainViewCollectionView.swift
//  MARU
//
//  Created by psychehose on 2021/05/05.
//

import UIKit

final class MainViewCollectionView: UICollectionView {
  private static var screenSize = UIScreen.main.bounds.size

  init() {
    super.init(frame: .zero, collectionViewLayout: MainViewCollectionView.createLayout())
  }
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  override var numberOfSections: Int {
    return 3
  }

  static func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in

      if sectionNumber == 0 {
        return self.generateFirstSection()
      } else if sectionNumber == 1 {
        return self.generateSecondSection()
      } else {
        return self.generateThirdSection()
      }
    }
  }

  static func generateFirstSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.edgeSpacing = .none

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .absolute(300))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])
    group.edgeSpacing = .none

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 0, leading: 0, bottom: 35, trailing: 0)
    return section
  }

  static func generateSecondSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(95),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(8),
                                                     top: nil,
                                                     trailing: .fixed(8),
                                                     bottom: nil)

    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(screenSize.width * 0.915),
                                           heightDimension: .estimated(180))

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 0, leading: 8, bottom: 35, trailing: 8)
    section.orthogonalScrollingBehavior = .continuous
    return section
  }

  static func generateThirdSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil,
                                                     top: nil,
                                                     trailing: nil,
                                                     bottom: nil)

    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(screenSize.width * 0.915),
                                           heightDimension: .absolute(142))

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])
    group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: .fixed(23))

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    return section
  }

}

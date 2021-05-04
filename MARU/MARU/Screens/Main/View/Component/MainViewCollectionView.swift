//
//  MainViewCollectionView.swift
//  MARU
//
//  Created by psychehose on 2021/05/05.
//

import UIKit

class MainViewCollectionView: UICollectionView {
  private static var screenSize = UIScreen.main.bounds.size

  init() {
    super.init(frame: .zero, collectionViewLayout: MainViewCollectionView.createLayout())
  }
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  override var numberOfSections: Int {
    return 2
  }

  static func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in

      if sectionNumber == 0 {
        return self.generateFirstSection()
      } else {
        return self.generateSecondSection()
      }
    }
  }
  static func generateFirstSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(81),
                                          heightDimension: .estimated(130))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(screenSize.width),
                                           heightDimension: .estimated(170))

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    return section
  }

  static func generateSecondSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(screenSize.width),
                                           heightDimension: .estimated(110))

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    return section
  }

}

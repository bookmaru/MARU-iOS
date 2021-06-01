//
//  LibraryViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/04/03.
//

import UIKit

final class LibraryViewController: BaseViewController {

  let profileBackgroundView = UIView().then {
    $0.backgroundColor = .white
  }

  let profileImageView = UIImageView().then { _ in
  }
  let mygradeLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.sizeToFit()
    $0.adjustsFontSizeToFitWidth = true
  }
  let preferenceButton = UIButton().then { _ in
  }
  let debateButton = UIButton().then {
    $0.sizeToFit()
    $0.setTitle("토론", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
  }
  let diaryButton = UIButton().then {
    $0.sizeToFit()
    $0.setTitle("독서일기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
  }
  var debateCollectionView: UICollectionView! = nil
  var diaryCollectionView: UICollectionView! = nil
  let addBookButton = UIButton().then {
    $0.sizeToFit()
    $0.layer.cornerRadius = 19
  }
  let screenSize = UIScreen.main.bounds.size

  override func viewDidLoad() {
    super.viewDidLoad()
//    view.backgroundColor = .

  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: true)
  }
}
//
// MARK: Collection View Layout
extension LibraryViewController {

  private func creatDebateLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) in

      if sectionNumber == 1 {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(57),
                                              heightDimension: .estimated(85))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(5),
                                                         top: nil,
                                                         trailing: .fixed(5),
                                                         bottom: nil)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.915),
                                               heightDimension: .fractionalHeight(1/2))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 5,
                                                        bottom: 0,
                                                        trailing: 5)
        section.orthogonalScrollingBehavior = .continuous
        return section
      }
      else {

        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(57),
                                              heightDimension: .estimated(85))
        

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(5),
                                                         top: nil,
                                                         trailing: .fixed(5),
                                                         bottom: nil)


        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.915),
                                               heightDimension: .fractionalHeight(1/2))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 5,
                                                        bottom: 0,
                                                        trailing: 5)
        section.orthogonalScrollingBehavior = .continuous
        return section
      }
    }
    return layout
  }
//  private func creatDiaryLayout() -> UICollectionViewCompositionalLayout {
//    let layout = UICollectionViewCompositionalLayout { (_, _) in
//
//      let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(57),
//                                              heightDimension: <#T##NSCollectionLayoutDimension#>)
//
//      let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//      let groupSize = NSCollectionLayoutSize(widthDimension: <#T##NSCollectionLayoutDimension#>,
//                                               heightDimension: .fractionalHeight(1/2))
//
//      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                       subitems: [item])
//
//
//        let section = NSCollectionLayoutSection(group: group)
//        return section
//    }
//    return layout
//  }
}

extension LibraryViewController {

  private func applyLayout() {
    debateCollectionView = UICollectionView(frame: .zero, collectionViewLayout: creatDebateLayout())
    debateCollectionView.register(LibraryDebateCell.self,
                            forCellWithReuseIdentifier: LibraryDebateCell.reuseIdentifier)
    debateCollectionView.register(SectionHeader.self,
                            forSupplementaryViewOfKind: SectionHeader.sectionHeaderElementKind,
                            withReuseIdentifier: SectionHeader.reuseIdentifier)

    debateCollectionView.delegate = self

    view.adds([
      profileBackgroundView,
      debateCollectionView
    ])

    profileBackgroundView.adds([
      profileImageView,
      mygradeLabel,
      preferenceButton,
      debateButton,
      diaryButton
    ])

    debateCollectionView.add(addBookButton)

    profileBackgroundView.snp.makeConstraints { make in
      make.width.equalTo(screenSize.width)
    }

    profileImageView.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 66, height: 66))
    }
    mygradeLabel.snp.makeConstraints { make in
    }
    preferenceButton.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 15, height: 15))
    }
    debateButton.snp.makeConstraints { make in
    }
    diaryButton.snp.makeConstraints { make in
    }
    debateCollectionView.snp.makeConstraints { make in

    }
    addBookButton.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 38, height: 38))
    }

  }
}

extension LibraryViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("later")
  }
}

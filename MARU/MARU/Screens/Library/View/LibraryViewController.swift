//
//  LibraryViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/04/03.
//

import UIKit

final class LibraryViewController: BaseViewController {

  enum Section {
    case wasDebate
    case willDebate
  }

  private let profileBackgroundView = UIView().then {
    $0.backgroundColor = .white
  }
  private let profileImageView = UIImageView().then {
    $0.sizeToFit()
    $0.backgroundColor = .red
    $0.layer.cornerRadius = ($0.bounds.width/2)
  }
  private let myNameGradeLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.sizeToFit()
    $0.adjustsFontSizeToFitWidth = true
    $0.text = "유진\n방장 평점 4.5"
    $0.font = .systemFont(ofSize: 18, weight: .bold)
  }
  private let preferenceButton = UIButton().then {
    $0.sizeToFit()
    $0.backgroundColor = .white
    $0.setImage(UIImage(systemName: "gearshape")?
                  .withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .heavy))
                  .withTintColor(.brownGreyFour, renderingMode: .alwaysOriginal),
                for: .normal)
  }
  private let writeButton = UIButton().then {
    $0.sizeToFit()
    $0.backgroundColor = .white
    $0.setImage(UIImage(systemName: "pencil")?
                  .withConfiguration(UIImage.SymbolConfiguration(pointSize: 21, weight: .black))
                  .withTintColor(.brownGreyFour, renderingMode: .alwaysOriginal),
                for: .normal)
    $0.layer.cornerRadius = 18
    $0.applyShadow(color: .black, alpha: 0.1, shadowX: 0, shadowY: 0, blur: 15)
  }
  private let debateButton = UIButton().then {
    $0.tag = 0
    $0.sizeToFit()
    $0.setTitle("토론", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
    $0.setTitleColor(.brownGreyThree, for: .normal)
    $0.setTitleColor(.blue, for: .selected)
    $0.contentEdgeInsets.bottom = 13
    $0.addTarget(self, action: #selector(didTapDebateOrDiaryButton(_ :)), for: .touchUpInside)
    $0.isSelected = true
  }
  private let debateLine = UIView().then {
    $0.backgroundColor = .blue
    $0.alpha = 1
  }
  private let diaryButton = UIButton().then {
    $0.tag = 1
    $0.sizeToFit()
    $0.setTitle("독서일기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
    $0.setTitleColor(.brownGreyThree, for: .normal)
    $0.setTitleColor(.blue, for: .selected)
    $0.contentEdgeInsets.bottom = 13
    $0.addTarget(self, action: #selector(didTapDebateOrDiaryButton(_ :)), for: .touchUpInside)
  }
  private let diaryLine = UIView().then {
    $0.backgroundColor = .brownishGrey
    $0.alpha = 0.1
  }
  private var debateCollectionView: UICollectionView! = nil
  private var diaryCollectionView: UICollectionView! = nil
  private var dataSource: UICollectionViewDiffableDataSource<Section, MainModel>! = nil
  private let screenSize = UIScreen.main.bounds.size

  var allModel: [MainModel] = [
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "B",
                                   bookAuthor: "B",
                                   bookComment: "B",
                                   roomChief: "B",
                                   category: 2)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "B",
                                   bookAuthor: "B",
                                   bookComment: "B",
                                   roomChief: "B",
                                   category: 2)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "C",
                                   bookAuthor: "C",
                                   bookComment: "C",
                                   roomChief: "C",
                                   category: 3))
  ]
  var allModel2: [MainModel] = [
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1)),
    MainModel.init(book: Book.init(bookImage: "",
                                   bookTitle: "A",
                                   bookAuthor: "A",
                                   bookComment: "A",
                                   roomChief: "A",
                                   category: 1))
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    applyLayout()
    configureDataSource()
    applySnapshot(animatingDifferences: false)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: true)
  }

  @objc func didTapDebateOrDiaryButton(_ sender: UIButton) {
    let buttons = [debateButton, diaryButton]
    let transferLine = UIViewPropertyAnimator(duration: 0.2,
                                              curve: .easeIn,
                                              animations: nil)
    if sender.isSelected == false {
      switch sender.tag {
      case 0:
        buttons[0].isSelected = true
        buttons[1].isSelected = false
        transferLine.addAnimations {
          self.debateLine.backgroundColor = .blue
          self.debateLine.alpha = 1
          self.diaryLine.backgroundColor = .brownishGrey
          self.diaryLine.alpha = 0.1
        }
      case 1:
        buttons[0].isSelected = false
        buttons[1].isSelected = true

        transferLine.addAnimations {
          self.debateLine.backgroundColor = .brownishGrey
          self.debateLine.alpha = 0.1
          self.diaryLine.backgroundColor = .blue
          self.diaryLine.alpha = 1
        }

      default:
        break
      }
      transferLine.startAnimation()
    }
  }
}

extension LibraryViewController {

  /// - TAG: Collection View Layout
  private func creatDebateLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { ( sectionNumber, _ ) in

      if sectionNumber == 0 {
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .estimated(self.screenSize.width * 0.915),
                                                      heightDimension: .estimated(20))

        // MARK: - SectionHeader는 Main Cell에서 만든 것을 재활용하는 것.
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerFooterSize,
          elementKind: SectionHeader.sectionHeaderElementKind, alignment: .top)

        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(57),
                                              heightDimension: .absolute(85))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(5),
                                                         top: nil,
                                                         trailing: .fixed(5),
                                                         bottom: nil)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.915),
                                               heightDimension: .estimated(self.screenSize.height * 0.269))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 13,
                                                        leading: 32,
                                                        bottom: (self.screenSize.height * 0.096),
                                                        trailing: 32)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
        return section

      } else {

        let headerFooterSize = NSCollectionLayoutSize(widthDimension:
                                                        .estimated(self.screenSize.width * 0.915),
                                                      heightDimension: .estimated(20))

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerFooterSize,
          elementKind: SectionHeader.sectionHeaderElementKind, alignment: .top)

        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(57),
                                              heightDimension: .absolute(85))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(5),
                                                         top: nil,
                                                         trailing: .fixed(5),
                                                         bottom: nil)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.915),
                                               heightDimension: .estimated(self.screenSize.height * 0.269))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 13,
                                                        leading: 32,
                                                        bottom: 0,
                                                        trailing: 32)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
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
  /// - TAG: Layout
  private func applyLayout() {
    debateCollectionView = UICollectionView(frame: .zero, collectionViewLayout: creatDebateLayout())
    debateCollectionView.delegate = self
    debateCollectionView.register(LibraryDebateCell.self,
                                  forCellWithReuseIdentifier: LibraryDebateCell.reuseIdentifier)
    debateCollectionView.register(SectionHeader.self,
                                  forSupplementaryViewOfKind: SectionHeader.sectionHeaderElementKind,
                                  withReuseIdentifier: SectionHeader.reuseIdentifier)
    debateCollectionView.backgroundColor = .white
    view.adds([
      profileBackgroundView,
      debateCollectionView
    ])

    profileBackgroundView.adds([
      preferenceButton,
      profileImageView,
      myNameGradeLabel,
      writeButton,
      debateButton,
      diaryButton
    ])

    debateButton.add(debateLine)
    diaryButton.add(diaryLine)

    profileBackgroundView.snp.makeConstraints { make in
      make.width.equalTo(screenSize.width)
      make.top.equalTo(view.safeAreaLayoutGuide).inset(0)
      make.height.equalTo(screenSize.height * (0.328))
      make.leading.equalTo(view.safeAreaLayoutGuide)
    }

    profileImageView.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 66, height: 66))
      make.leading.equalToSuperview().inset(30)
      make.top.equalToSuperview().inset(74)
    }

    myNameGradeLabel.snp.makeConstraints { make in
      make.leading.equalTo(profileImageView.snp.trailing).inset(-18)
      make.top.equalToSuperview().inset(74)
    }
    writeButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(30)
      make.size.equalTo(CGSize(width: 36, height: 36))
      make.centerY.equalTo(profileImageView.snp.centerY)
    }

    preferenceButton.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 15, height: 15))
      make.top.equalToSuperview().inset(12)
      make.trailing.equalToSuperview().inset(20)
    }

    debateButton.snp.makeConstraints { make in
      make.width.equalTo(screenSize.width/2)
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
    }
    debateLine.snp.makeConstraints { make in
      make.width.equalTo(screenSize.width/2)
      make.height.equalTo(1)
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
    }

    diaryButton.snp.makeConstraints { make in
      make.width.equalTo(screenSize.width/2)
      make.bottom.equalToSuperview()
      make.trailing.equalToSuperview()
    }

    diaryLine.snp.makeConstraints { make in
      make.width.equalTo(screenSize.width/2)
      make.height.equalTo(1)
      make.bottom.equalToSuperview()
      make.trailing.equalToSuperview()
    }

    debateCollectionView.snp.makeConstraints { make in
      make.top.equalTo(profileBackgroundView.snp.bottom).inset(-30)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
    }
  }
}

extension LibraryViewController {
  private func configureDataSource() {

    let cellRegistration = UICollectionView.CellRegistration<LibraryDebateCell, MainModel> { (_, _, _) in
      // Populate the cell with our item description.

    }
    let headerRegistration = UICollectionView.SupplementaryRegistration
    <SectionHeader>(elementKind: SectionHeader.sectionHeaderElementKind) { (supplementaryView, _, indexPath) in
      if indexPath.section == 0 {
        supplementaryView.hideMoveButton(isHidden: false)
        supplementaryView.hidePlusButton(isHidden: false)
        supplementaryView.setupText(text: "참여했던 토론방")

      } else {
        supplementaryView.hideMoveButton(isHidden: false)
        supplementaryView.hidePlusButton(isHidden: false)
        supplementaryView.setupText(text: "담아둔 토론하고 싶은 책")
      }
    }

    dataSource
      = UICollectionViewDiffableDataSource<Section, MainModel>(
        collectionView: debateCollectionView
      ) {(collectionView, indexPath, identifier) -> UICollectionViewCell? in
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                            for: indexPath,
                                                            item: identifier)
      }
    dataSource.supplementaryViewProvider = { (_, _, index) in
      return self.debateCollectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                              for: index)
    }
  }

  func applySnapshot(animatingDifferences: Bool = true) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, MainModel>()
    snapshot.appendSections([.wasDebate, .willDebate])
    snapshot.appendItems(allModel, toSection: .wasDebate)
    snapshot.appendItems(allModel2, toSection: .willDebate)
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}

extension LibraryViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let mainModel = dataSource.itemIdentifier(for: indexPath) else {
      return
    }
  }
}

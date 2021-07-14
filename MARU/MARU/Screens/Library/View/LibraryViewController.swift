//
//  LibraryViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/04/03.
//

import UIKit

final class LibraryViewController: BaseViewController {

  enum Section {
    case meetingHeld
    case willDebate
  }

  private let profileBackgroundView = UIView().then {
    $0.backgroundColor = .white
  }
  private let profileImageView = UIImageView().then {
    $0.sizeToFit()
    $0.image = Image.appIcon
    $0.backgroundColor = .white
  }
  private let myNameLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.text = "유진"
    $0.font = .systemFont(ofSize: 16, weight: .bold)
  }
  private let gradeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .regular)
    $0.textColor = .gray
    let attributeString = NSMutableAttributedString(string: "방장 평점 4.5")
    let multipleAttribute: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12, weight: .heavy)
    ]
    attributeString.addAttributes(multipleAttribute, range: NSRange(location: 6, length: 3))
    $0.attributedText = attributeString
  }
  private let preferenceButton = UIButton().then {
    $0.backgroundColor = .white
    $0.setImage(UIImage(systemName: "gearshape")?
                  .withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))
                  .withTintColor(.brownGreyFour, renderingMode: .alwaysOriginal),
                for: .normal)
  }
  private let writeButton = UIButton().then {
    $0.sizeToFit()
    $0.backgroundColor = .white
    $0.setImage(UIImage(systemName: "pencil")?
                  .withConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .regular))
                  .withTintColor(.lightGray,
                                 renderingMode: .alwaysOriginal),
                for: .normal)
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.lightGray.cgColor
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
  private var dataSource: UICollectionViewDiffableDataSource<Section, LibraryModel>! = nil
  private let screenSize = UIScreen.main.bounds.size

  var allModel = LibraryModel.initData
  var allModel2 = LibraryModel.initData2

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
  override func viewWillLayoutSubviews() {
    profileImageView.clipsToBounds = true
    profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
    writeButton.layer.cornerRadius = writeButton.bounds.height / 2
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
extension LibraryViewController: ButtonDelegate {
  func didPressButtonInHeader(_ tag: Int) {
    switch tag {
    case 0:
      let targetViewController = MeetingHeldViewController()
      targetViewController.navigationItem.title = "담아둔 모임"
      self.navigationController?.pushViewController(targetViewController, animated: true)
    default:
      return
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
      myNameLabel,
      gradeLabel,
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
      make.size.equalTo(CGSize(width: 75, height: 75))
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(44)
    }
    myNameLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(profileImageView.snp.bottom).inset(-12)
    }
    gradeLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(myNameLabel.snp.bottom).inset(-8)
    }
    writeButton.snp.makeConstraints { make in
      make.trailing.equalTo(profileImageView.snp.trailing)
      make.size.equalTo(CGSize(width: 19, height: 19))
      make.bottom.equalTo(profileImageView.snp.bottom)
    }
    preferenceButton.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 40, height: 40))
      make.top.equalToSuperview().inset(4)
      make.trailing.equalToSuperview().inset(10)
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

    let cellRegistration = UICollectionView.CellRegistration<LibraryDebateCell, LibraryModel> { (_, _, _) in
      // Populate the cell with our item description.
    }
    let headerRegistration = UICollectionView.SupplementaryRegistration
    <SectionHeader>(elementKind: SectionHeader.sectionHeaderElementKind) { (supplementaryView, _, indexPath) in

      supplementaryView.delegate = self
      supplementaryView.setupButtonTag(itemNumber: indexPath.section)

      if indexPath.section == 0 {
        supplementaryView.hideMoveButton(isHidden: false)
        supplementaryView.setupText(text: "담아둔 모임")
      } else {
        supplementaryView.hideMoveButton(isHidden: false)
        supplementaryView.setupText(text: "모임하고 싶은 책")
      }
    }

    dataSource
      = UICollectionViewDiffableDataSource<Section, LibraryModel>(
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
    var snapshot = NSDiffableDataSourceSnapshot<Section, LibraryModel>()
    snapshot.appendSections([.meetingHeld, .willDebate])
    snapshot.appendItems(allModel, toSection: .meetingHeld)
    snapshot.appendItems(allModel2, toSection: .willDebate)
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}

extension LibraryViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard dataSource.itemIdentifier(for: indexPath) != nil else {
      return
    }
  }
}

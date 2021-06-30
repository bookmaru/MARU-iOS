//
//  MorePopularViewController.swift
//  MARU
//
//  Created by psychehose on 2021/05/29.
//

import UIKit

final class MoreNewViewController: BaseViewController {

  enum Section {
    case main
  }

  enum Category: Int {
    case all = 0
    case art
    case literal
    case science
    case philosophy
  }

  private let titleButton = UIButton().then {
    $0.sizeToFit()
    $0.titleLabel?.textAlignment = .left
    $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    $0.setTitleColor(.black, for: .normal)
    $0.setTitle("지금 새로나온 모임", for: .normal)
    $0.backgroundColor = .white
    $0.addTarget(self, action: #selector(didTapTitleButton), for: .touchUpInside)
  }

  private var allButton: UIButton = UIButton()
  private var artButton: UIButton = UIButton()
  private var literalButton: UIButton = UIButton()
  private var scienceButton: UIButton = UIButton()
  private var philosophyButton: UIButton = UIButton()

  private lazy var dataSource = configureDataSource()
  private var collectionView: UICollectionView! = nil
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

  private var categoryFilter: String?

  typealias DataSource = UICollectionViewDiffableDataSource<Section, MainModel>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MainModel>

  override func viewDidLoad() {
    super.viewDidLoad()
    setupButton(title: ["전체", "예술", "문학", "자연과학", "철학"])
    applyLayout()
    applySnapshot(animatingDifferences: false)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: false)
    self.navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    self.navigationController?.navigationBar.isTranslucent = false
  }

  @objc func performQuery(sender: UIButton) {
    switch sender.tag {
    case 0:
      applySnapshot(animatingDifferences: true)

    default:
      var snapshot = Snapshot()
      let books = allModel.filter({ $0.book.category == sender.tag})
      snapshot.appendSections([.main])
      snapshot.appendItems(books)
      dataSource.apply(snapshot, animatingDifferences: true)
    }
  }
  @objc func didTapTitleButton() {
    collectionView.setContentOffset(.zero, animated: true)
  }
}

// MARK: - Method Helper
extension MoreNewViewController {

  private func setupButton(title: [String]) {
    [allButton,
     artButton,
     literalButton,
     scienceButton,
     philosophyButton].enumerated().forEach { index, button in
      button.backgroundColor = .white
      button.layer.borderWidth = 1
      button.layer.borderColor = UIColor.veryLightPinkFour.cgColor
      button.layer.cornerRadius = 14
      button.sizeToFit()
      button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
      button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
      button.setTitleColor(.brownGreyThree, for: .normal)
      button.titleLabel?.textAlignment = .center
      button.setTitle(title[index], for: .normal)
      button.tag = index
      button.addTarget(self, action: #selector(performQuery), for: .touchUpInside)
     }
  }
}

extension MoreNewViewController {
  /// - Tag: create CollectionView Layout

  private func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { [self] (_, _) in
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
      section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
      return section
    }
    return layout
  }

  /// - TAG: View Layout
  private func applyLayout() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    collectionView.backgroundColor = .white
    collectionView.delegate = self
    collectionView.register(cell: MeetingListCell.self)

    view.adds([
      titleButton,
      allButton,
      artButton,
      literalButton,
      scienceButton,
      philosophyButton,
      collectionView
    ])

    titleButton.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(0)
      make.leading.equalToSuperview().inset(20)
      make.height.equalTo(20)
    }

    allButton.snp.makeConstraints { (make) in
      make.top.equalTo(titleButton.snp.bottom).inset(-8)
      make.leading.equalToSuperview().inset(20)
    }

    artButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(allButton.snp.centerY)
      make.leading.equalTo(allButton.snp.trailing).inset(-5)
    }

    literalButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(allButton.snp.centerY)
      make.leading.equalTo(artButton.snp.trailing).inset(-5)
    }

    scienceButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(allButton.snp.centerY)
      make.leading.equalTo(literalButton.snp.trailing).inset(-5)
    }

    philosophyButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(allButton.snp.centerY)
      make.leading.equalTo(scienceButton.snp.trailing).inset(-5)
    }

    collectionView.snp.makeConstraints { (make) in
      make.top.equalTo(allButton.snp.bottom).inset(-14)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }
}

extension MoreNewViewController {

  /// - TAG: DataSource
  private func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView,
      cellProvider: { (collectionView, indexPath, mainModel) -> UICollectionViewCell? in

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingListCell.reuseIdentifier,
                                                      for: indexPath) as? MeetingListCell
        cell?.mainModel = mainModel
        return cell
      })

    return dataSource
  }

  func applySnapshot(animatingDifferences: Bool = true) {
    // 2
    var snapshot = Snapshot()
    // 3
    snapshot.appendSections([.main])
    snapshot.appendItems(allModel)
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}
// MARK: 나중에 써야해서 남겨놓습니다.

extension MoreNewViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let mainModel = dataSource.itemIdentifier(for: indexPath) else {
      return
    }
  }
}

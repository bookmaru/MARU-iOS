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

  private var allButton: UIButton = UIButton()
  private var artButton: UIButton = UIButton()
  private var literalButton: UIButton = UIButton()
  private var scienceButton: UIButton = UIButton()
  private var philosophyButton: UIButton = UIButton()

  private lazy var dataSource = configureDataSource()
  private var collectionView: UICollectionView! = nil
  private let screenSize = UIScreen.main.bounds.size

  private var initData = MainModel.initMainData

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
      let books = initData.filter({ $0.book.category == sender.tag})
      snapshot.appendSections([.main])
      snapshot.appendItems(books)
      dataSource.apply(snapshot, animatingDifferences: true)
    }
  }
}

// MARK: - Method Helper
extension MoreNewViewController {

  private func setupButton(title: [String]) {
    [allButton,
     artButton,
     literalButton,
     scienceButton,
     philosophyButton]
      .enumerated().forEach { index, button in
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

  /// - TAG: View Layout
  private func applyLayout() {
    collectionView = UICollectionView(frame: .zero,
                                      collectionViewLayout: MaruListCollectionViewLayout.createLayout())
    collectionView.backgroundColor = .white
    collectionView.delegate = self
    collectionView.register(cell: MeetingListCell.self)

    view.adds([
      allButton,
      artButton,
      literalButton,
      scienceButton,
      philosophyButton,
      collectionView
    ])

    allButton.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
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
    snapshot.appendItems(initData)
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

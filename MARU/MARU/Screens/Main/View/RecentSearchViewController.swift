//
//  RecentSearchViewController.swift
//  MARU
//
//  Created by psychehose on 2021/06/26.
//

import UIKit

final class RecentSearchViewController: BaseViewController {
  enum Section {
    case main
  }

  lazy var searchView = MaruSearchView(width: screenSize.width * 0.787,
                                       height: screenSize.height * 0.055).then {
                                        $0.delegate = self
                                       }
  private let searchButton = UIButton().then {
    $0.sizeToFit()
    $0.setTitle("검색", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
    $0.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }

  private let recentSearchLabel = UILabel().then {
    $0.sizeToFit()
    $0.adjustsFontSizeToFitWidth = true
    $0.text = "최근 검색어"
    $0.textColor = .mainBlue
    $0.font = .systemFont(ofSize: 13, weight: .bold)
  }

  private let deleteLabel = UILabel().then {
    $0.sizeToFit()
    $0.adjustsFontSizeToFitWidth = true
    $0.text = "전체 삭제"
    $0.textColor = .black
    $0.alpha = 0.29
    $0.font = .systemFont(ofSize: 12, weight: .bold)
  }

  private let screenSize = UIScreen.main.bounds.size
  private var searchListCollectionView: UICollectionView! = nil
  private var resultCollectionView: UICollectionView! = nil
  private var recentDataSource: UICollectionViewDiffableDataSource<Section, String>!
  private var resultDataSource: UICollectionViewDiffableDataSource<Section, MainModel>!

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
                                   category: 1))
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    configureLayout()
    configureDataSource()
    configureResultDataSource()
    searchListCollectionView.contentInsetAdjustmentBehavior = .never
    resultCollectionView.contentInsetAdjustmentBehavior = .never
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: false)
    self.navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    self.navigationController?.navigationBar.isTranslucent = false
  }

  @objc func didTapButton() {
    remakeLayout()
    searchView.searchTextField.resignFirstResponder()
  }

}

extension RecentSearchViewController {

  /// - TAG: collectionView Layout

  private func createListLayout() -> UICollectionViewLayout {
    var config = UICollectionLayoutListConfiguration(appearance: .plain)
    config.showsSeparators = false
    return UICollectionViewCompositionalLayout.list(using: config)
  }

  private func createResultLayout() -> UICollectionViewLayout {
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
      group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil,
                                                        top: nil,
                                                        trailing: nil,
                                                        bottom: .fixed(23))

      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
      return section
    }
    return layout
  }

  private func configureLayout() {
    searchListCollectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: createListLayout())
    searchListCollectionView.delegate = self
    resultCollectionView = UICollectionView(frame: .zero,
                                            collectionViewLayout: createResultLayout())
    resultCollectionView.delegate = self
    searchListCollectionView.backgroundColor = .white
    resultCollectionView.backgroundColor = .white
    resultCollectionView.isHidden = true

    view.add(searchView) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(5)
        make.leading.equalToSuperview().inset(20)
      }
    }
    view.add(searchButton) {
      $0.snp.makeConstraints { make in
        make.centerY.equalTo(self.searchView.snp.centerY)
        make.trailing.equalToSuperview().inset(12)
      }
    }
    view.add(recentSearchLabel) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.searchView.snp.bottom).inset(-17)
        make.leading.equalToSuperview().inset(20)
      }
    }
    view.add(deleteLabel) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.searchView.snp.bottom).inset(-22)
        make.trailing.equalToSuperview().inset(20)
      }
    }
    view.add(searchListCollectionView) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.searchView.snp.bottom).inset(-49)
        make.leading.equalToSuperview().inset(27)
        make.trailing.equalToSuperview().inset(27)
        make.bottom.equalToSuperview()
      }
    }
    view.add(resultCollectionView) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.searchView.snp.bottom).inset(-16)
        make.leading.equalToSuperview()
        make.trailing.equalToSuperview()
        make.bottom.equalToSuperview()
      }
    }
  }

  private func remakeLayout() {
    searchListCollectionView.isHidden = true
    deleteLabel.isHidden = true
    recentSearchLabel.isHidden = true
    resultCollectionView.isHidden = false
  }

  private func backLayout() {
    recentSearchLabel.isHidden = false
    deleteLabel.isHidden = false
    searchListCollectionView.isHidden = false
    resultCollectionView.isHidden = true
  }
}

extension RecentSearchViewController {
  /// - TAG: DataSource
  private func configureDataSource() {
    let cellRegistration = UICollectionView
      .CellRegistration<UICollectionViewListCell, String> { (cell, _, item) in
        var content = cell.defaultContentConfiguration()
        content.text = item
        cell.contentConfiguration = content
      }
    recentDataSource =
      UICollectionViewDiffableDataSource<Section, String>(
        collectionView: searchListCollectionView,
        cellProvider: {(collectionView, indexPath, string) -> UICollectionViewCell in
          return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: string)})

    var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    snapshot.appendSections([.main])
    snapshot.appendItems(["살려줘", "노르웨이의 숲", "물리의 정석", "라라룰"])
    recentDataSource.apply(snapshot, animatingDifferences: false)
  }

  private func configureResultDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<MeetingListCell, MainModel> { (_, _, _) in
      // Populate the cell with our item description.
    }
    resultDataSource
      = UICollectionViewDiffableDataSource<Section, MainModel>(
        collectionView: resultCollectionView
      ) { (collectionView, indexPath, identifier ) -> UICollectionViewCell? in
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                            for: indexPath,
                                                            item: identifier)
      }

    var snapshot = NSDiffableDataSourceSnapshot<Section, MainModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(allModel)
    resultDataSource.apply(snapshot, animatingDifferences: false)
  }
}
extension RecentSearchViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
}

extension RecentSearchViewController: SearchTextFieldDelegate, UITextFieldDelegate {
  func tapTextField() {
    backLayout()
  }
}

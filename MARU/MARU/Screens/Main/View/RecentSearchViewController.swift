//
//  RecentSearchViewController.swift
//  MARU
//
//  Created by psychehose on 2021/06/26.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift

final class RecentSearchViewController: BaseViewController {

  enum Section {
    case main
  }

  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "검색을 해주세요"
    return searchBar
  }()

  private var cancelButton: UIBarButtonItem = {
    let cancelButton = UIBarButtonItem()
    cancelButton.tintColor = .black
    cancelButton.title = "취소"
    return cancelButton
  }()

  private let recentSearchLabel: UILabel = {
    let recentSearchLabel = UILabel()
    recentSearchLabel.text = "최근 검색어"
    recentSearchLabel.textColor = .mainBlue
    recentSearchLabel.font = .systemFont(ofSize: 13, weight: .bold)
    return recentSearchLabel
  }()

  private let deleteButton: UIButton = {
    let deleteButton = UIButton()
    deleteButton.setTitle("전체 삭제", for: .normal)
    deleteButton.setTitleColor(.black, for: .normal)
    deleteButton.setTitleColor(.black22, for: .highlighted)
    deleteButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
    deleteButton.alpha = 0.29
    return deleteButton
  }()

  private let screenSize = UIScreen.main.bounds.size
  private var searchListCollectionView: UICollectionView! = nil
  private var searchListDataSource: UICollectionViewDiffableDataSource<Section, String>!

  private var viewModel =  RecentSearchViewModel()
  private let tapListCell = PublishSubject<String>()

  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBar(isHidden: false)
    configureLayout()
    bind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    navigationController?.navigationBar.isTranslucent = false
    tabBarController?.tabBar.isHidden = true
    configureSearchBar()
  }

  private func bind() {
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_: )))
      .map { _ in () }
      .asDriver(onErrorJustReturn: ())

    let input = RecentSearchViewModel.Input(
      viewTrigger: Driver.merge(viewWillAppear),
      tapCancelButton: cancelButton.rx.tap.asDriver(),
      tapDeleteButton: deleteButton.rx.tap.asDriver(),
      writeText: searchBar.rx.text.orEmpty.asDriver(),
      tapSearchButton: searchBar.rx.searchButtonClicked.asDriver(),
      tapListCell: tapListCell.asDriver(onErrorJustReturn: "")
    )

    let output = viewModel.transform(input: input)

    output.load
      .drive { [weak self] in
        guard let self = self else { return }
        var recentKeywords: [String] = []
        $0.forEach { recentKeyword in
          recentKeywords.append(recentKeyword.keyword)
        }
        self.configureSearchListDataSource(recentKeywords)
      }
      .disposed(by: disposeBag)

    output.cancel
      .drive { [weak self] in
        guard let self = self, $0 else { return }
        self.view.hideKeyboard()
        self.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)

    output.delete
      .drive(onNext: { [weak self] in
        self?.configureSearchListDataSource([])
      })
      .disposed(by: disposeBag)

    output.keyword
      .drive { [weak self] in
        guard let self = self else { return }
        self.searchBar.text = ""
        let resultSearchViewController = ResultSearchViewController()
        resultSearchViewController.transferKeyword(keyword: $0)
        self.navigationController?.pushViewController(resultSearchViewController, animated: false)
      }
      .disposed(by: disposeBag)

  }
}

extension RecentSearchViewController {
  private func configureSearchBar() {
    navigationItem.leftBarButtonItem = nil
    navigationItem.hidesBackButton = true
    navigationItem.titleView = searchBar
    navigationItem.rightBarButtonItem = cancelButton
  }
}

extension RecentSearchViewController {

  /// - TAG: collectionView Layout

  private func createListLayout() -> UICollectionViewLayout {
    var config = UICollectionLayoutListConfiguration(appearance: .plain)
    config.showsSeparators = false
    return UICollectionViewCompositionalLayout.list(using: config)
  }

  private func configureLayout() {
    searchListCollectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: createListLayout()
    )
    searchListCollectionView.delegate = self
    searchListCollectionView.contentInsetAdjustmentBehavior = .never
    searchListCollectionView.backgroundColor = .white
    searchListCollectionView.isHidden = false

    view.add(recentSearchLabel) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(17)
        make.leading.equalToSuperview().inset(20)
      }
    }
    view.add(deleteButton) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(22)
        make.trailing.equalToSuperview().inset(20)
      }
    }
    view.add(searchListCollectionView) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(49)
        make.leading.equalToSuperview().inset(27)
        make.trailing.equalToSuperview().inset(27)
        make.bottom.equalToSuperview()
      }
    }
  }
}

extension RecentSearchViewController {
  /// - TAG: DataSource
  private func configureSearchListDataSource(_ items: [String]) {
    let cellRegistration = UICollectionView
      .CellRegistration<UICollectionViewListCell, String> { cell, _, item in
        var content = cell.defaultContentConfiguration()
        content.text = item
        cell.contentConfiguration = content
      }

    searchListDataSource = UICollectionViewDiffableDataSource<Section, String>(
      collectionView: searchListCollectionView,
      cellProvider: { collectionView, indexPath, string -> UICollectionViewCell in
        return collectionView.dequeueConfiguredReusableCell(
          using: cellRegistration,
          for: indexPath,
          item: string)
      }
    )

    var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    searchListDataSource.apply(snapshot, animatingDifferences: false)
  }
}
extension RecentSearchViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    collectionView.deselectItem(at: indexPath, animated: true)
    guard let searchKeyword = searchListDataSource.itemIdentifier(for: indexPath) else {
      return
    }
    tapListCell.onNext(searchKeyword)
  }
}

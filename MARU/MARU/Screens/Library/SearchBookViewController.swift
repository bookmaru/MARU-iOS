//
//  SearchBookViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/14.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift

final class SearchBookViewController: BaseViewController {

  enum Section {
    case main
  }

  private let searchBar = UISearchBar().then {
    $0.placeholder = "책 제목"
  }

  private let recentSearchLabel = UILabel().then {
    $0.text = "최근 검색어"
    $0.textColor = .mainBlue
    $0.font = .systemFont(ofSize: 13, weight: .bold)
  }

  private let deleteButton = UIButton().then {
    $0.setTitle("전체 삭제", for: .normal)
    $0.setTitleColor(.lightGray, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
  }

  private var cancelButton = UIBarButtonItem().then {
    $0.tintColor = .black
    $0.title = "취소"
  }

  private var searchListCollectionView: UICollectionView! = nil
  private var searchListDataSource: UICollectionViewDiffableDataSource<Section, String>!
  private var viewModel = RecentSearchViewModel()
  private let tapListCell = PublishSubject<String>()

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    bind()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setSearchBar()
    // setNavigationBar(isHidden: true)
  }
}

extension SearchBookViewController {
  private func createListLayout() -> UICollectionViewLayout {
    var config = UICollectionLayoutListConfiguration(appearance: .plain)
    config.showsSeparators = false
    return UICollectionViewCompositionalLayout.list(using: config)
  }
  private func render() {
    searchListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createListLayout())
    searchListCollectionView.delegate = self
    searchListCollectionView.contentInsetAdjustmentBehavior = .never
    searchListCollectionView.backgroundColor = .white
    searchListCollectionView.isHidden = false

    view.add(recentSearchLabel) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).offset(17)
        make.leading.equalToSuperview().offset(20)
      }
    }

    view.add(deleteButton) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).offset(17)
        make.trailing.equalToSuperview().offset(-20)
      }
    }

    view.add(searchListCollectionView) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).offset(49)
        make.leading.equalToSuperview().offset(27)
        make.trailing.equalToSuperview().offset(-27)
        make.bottom.equalToSuperview()
      }
    }
  }

  private func setSearchBar() {
    navigationItem.leftBarButtonItem = nil
    navigationItem.hidesBackButton = true
    navigationItem.titleView = searchBar
    navigationItem.rightBarButtonItem = cancelButton
    navigationItem.rightBarButtonItem?.tintColor = .black
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
    // MARK: - 최근검색어 -> 결과화면 전환부
    output.keyword
      .drive { [weak self] in
        guard let self = self else { return }
        self.searchBar.text = ""
        let resultSearchViewController = ResultBookViewController(keyword: $0)
        //resultSearchViewController.transferKeyword(keyword: $0)
        self.navigationController?.pushViewController(resultSearchViewController, animated: false)
      }
      .disposed(by: disposeBag)

  }

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

extension SearchBookViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    collectionView.deselectItem(at: indexPath, animated: true)
    guard let searchKeyword = searchListDataSource.itemIdentifier(for: indexPath) else { return }
    tapListCell.onNext(searchKeyword)
  }
}

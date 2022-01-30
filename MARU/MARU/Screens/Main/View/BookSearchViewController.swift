//
//  BookSearchViewController.swift
//  MARU
//
//  Created by 김호세 on 2021/09/27.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class BookSearchViewController: BaseViewController {

  override var hidesBottomBarWhenPushed: Bool {
    get { navigationController?.topViewController == self }
    set { super.hidesBottomBarWhenPushed = newValue }
  }

  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "검색을 해주세요"
    return searchBar
  }()

  private let cancelButton: UIBarButtonItem = {
    let cancelButton = UIBarButtonItem()
    cancelButton.tintColor = .black
    cancelButton.title = "취소"
    return cancelButton
  }()

  private var collectionView: UICollectionView! = nil
  private let keyword: String
  private let viewModel = BookSearchViewModel()
  private let triggerMoreData = PublishSubject<Void>()
  private var canLoadMore: Bool = true

  private var bookModel: [BookModel] = [] {
    didSet {
      collectionView.reloadData()
      canLoadMore = true
    }
  }

  init(keyword: String) {
    self.keyword = keyword
    super.init()
    configureLayout()
    configureSearchBar()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .bgLightgray
    bind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: false)
    navigationController?.navigationBar.shadowImage = UIColor.bgLightgray.as1ptImage()
    navigationController?.navigationBar.isTranslucent = false
  }

  private func bind() {
    let viewTrigger = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in self.keyword }
      .asObservable()

    let input = BookSearchViewModel.Input(
      viewTrigger: viewTrigger,
      tapCancelButton: cancelButton.rx.tap.asObservable(),
      writeText: searchBar.rx.text.orEmpty.asObservable(),
      tapSearchButton: searchBar.rx.searchButtonClicked.asObservable(),
      fetchMore: triggerMoreData.asObserver()
    )
    let output = viewModel.transform(input: input)

    output.result
      .drive { [weak self] bookModel in
        guard let self = self else { return }
        if !bookModel.isEmpty {
          self.bookModel.append(contentsOf: bookModel)
        }
      }
      .disposed(by: disposeBag)
    output.cancel
      .drive(onNext: { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    output.reSearch
      .drive(onNext: { [weak self] in
        self?.bookModel.removeAll()
      })
      .disposed(by: disposeBag)
    output.errorMessage
      .subscribe(onNext: {
        debugPrint($0)
      })
      .disposed(by: disposeBag)
  }
}
extension BookSearchViewController {

  private func configureLayout() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .bgLightgray
    collectionView.register(cell: BookListCell.self, forCellWithReuseIdentifier: BookListCell.reuseIdentifier)
    collectionView.delegate = self
    collectionView.dataSource = self
    view.add(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
      make.bottom.equalTo(view.snp.bottom)
    }
  }

  private func configureSearchBar() {
    navigationItem.leftBarButtonItem = nil
    navigationItem.hidesBackButton = true
    navigationItem.titleView = searchBar
    navigationItem.rightBarButtonItem = cancelButton
    searchBar.backgroundImage = UIImage()
    searchBar.searchTextField.backgroundColor = .white
    searchBar.searchTextField.text = keyword
    extendedLayoutIncludesOpaqueBars = true
  }

}

extension BookSearchViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return bookModel.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookListCell.reuseIdentifier,
            for: indexPath
    ) as? BookListCell else { return UICollectionViewCell() }
    cell.bind(bookModel[indexPath.item])
    return cell
  }
}
extension BookSearchViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: 335.calculatedWidth, height: 142)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 20
  }
}

extension BookSearchViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    if indexPath.item == bookModel.endIndex - 1 && canLoadMore {
      canLoadMore = false
      triggerMoreData.onNext(())
    }
  }
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let targetViewController = CreateQuizViewController(bookModel: bookModel[indexPath.item])
    navigationController?.pushViewController(targetViewController, animated: true)
  }
}

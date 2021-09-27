//
//  ResultBookViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/20.
//

import UIKit

import RxSwift
import RxCocoa

class ResultBookViewController: BaseViewController, UISearchBarDelegate {

  enum Section {
    case main
  }

  private let searchBar = UISearchBar().then {
    $0.placeholder = "책 제목"
  }

  private let cancelButton = UIBarButtonItem().then {
    $0.tintColor = .black
    $0.title = "취소"
  }

  private let activatorView = UIActivityIndicatorView().then {
    $0.startAnimating()
    $0.hidesWhenStopped = true
  }
  //private var resultCollectionView: UICollectionView! = nil
  private var resultCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let resultCollectionView = UICollectionView(frame: .zero,
                                            collectionViewLayout: MaruListCollectionViewLayout.createLayout())
    resultCollectionView.contentInsetAdjustmentBehavior = .never
    resultCollectionView.backgroundColor = .white
    return resultCollectionView
  }()
  private var resultDataSource: UICollectionViewDiffableDataSource<Section, BookModel>!
  private var searchedKeyword: String! = nil
  private var viewModel =  ResultBookViewModel()
  private var keyword: String! = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    render()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setSearchBar()
  }

  init(keyword: String) {
    super.init()
    searchedKeyword = keyword
    searchBar.searchTextField.text = keyword
    self.keyword = keyword
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}

extension ResultBookViewController {
  private func bind() {
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in () }

    let input = ResultBookViewModel.Input(
      viewTrigger: viewWillAppear,
      keyword: keyword,
      tapCancelButton: cancelButton.rx.tap.asDriver(),
      tapTextField: Driver.merge(
        searchBar.searchTextField.rx.controlEvent(.touchDown).asDriver(),
        searchBar.rx.textDidBeginEditing.asDriver())
    )
    let output = viewModel.transform(input: input)

    output.result
      .drive { [self = self] in
        configureResultDataSource($0)
        activatorView.stopAnimating()
      }
      .disposed(by: disposeBag)

    output.cancel
      .drive(onNext: { [self = self] in
        navigationController?.popToRootViewController(animated: true)
      })
      .disposed(by: disposeBag)

    output.reSearch
      .drive(onNext: { [self = self] in
        navigationController?.popViewController(animated: false)
      })
      .disposed(by: disposeBag)

  }

  private func render() {
    view.adds([
      activatorView,
      resultCollectionView
    ])
    resultCollectionView.delegate = self
    //resultCollectionView.dataSource = self
    activatorView.snp.makeConstraints { make in
      make.center.equalTo(view.snp.center)
    }

    resultCollectionView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }

  func setSearchBar() {
    navigationItem.leftBarButtonItem = nil
    navigationItem.hidesBackButton = true
    navigationItem.titleView = searchBar
    navigationItem.rightBarButtonItem = cancelButton
    navigationItem.rightBarButtonItem?.tintColor = .black
  }

  @objc func didTapCancelButton() {
    self.navigationController?.popViewController(animated: false)
  }

  func transferKeyword(keyword: String) {
    searchedKeyword = keyword
    searchBar.searchTextField.text = keyword
    self.keyword = keyword
  }

  private func configureResultDataSource(_ items: [BookModel]) {
    let cellRegistration = UICollectionView
      .CellRegistration<ResultBookCell, BookModel> { cell, _, bookModel in
        cell.bind(bookModel)
        // TODO: POST 통신 방법 고민해보기
        cell.rx.didTapAddBookButton
          .subscribe(onNext: {
            let viewController = BookAlertViewController(Image.coolicon ?? UIImage(), "\(bookModel.title)이", "성공적으로 서재에 담겼습니다.")
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.modalTransitionStyle = .crossDissolve
            self.present(viewController, animated: true)
          })
          .disposed(by: cell.disposeBag )
      }

    resultDataSource = UICollectionViewDiffableDataSource<Section, BookModel>(
      collectionView: resultCollectionView
    ) { collectionView, indexPath, identifier -> UICollectionViewCell? in
      return collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: identifier
      )
    }

    var snapshot = NSDiffableDataSourceSnapshot<Section, BookModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    resultDataSource.apply(snapshot, animatingDifferences: false)


  }

}

extension ResultBookViewController: UICollectionViewDelegate {

}


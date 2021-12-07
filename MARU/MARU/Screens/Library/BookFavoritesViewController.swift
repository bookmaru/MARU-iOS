//
//  BookFavoritesViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/12.
//

import UIKit
import RxSwift
import RxCocoa

final class BookFavoritesViewController: BaseViewController {
  private let emptyView = UIView().then {
    $0.backgroundColor = .white
    $0.isHidden = true
  }

  private let bookImage = UIImageView().then {
    $0.image = Image.autoStories
  }

  let emptyLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = .subText
    $0.textAlignment = .center
    $0.text = """
    모임하고 싶은 책이 아직 없어요.
    + 버튼을 눌러 서재를 채워주세요!
    """
  }

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(cell: BookFavoritesShelfCell.self,
                            forCellWithReuseIdentifier: BookFavoritesShelfCell.reuseIdentifier)
    return collectionView
  }()

  private let bookShelfImageView = UIImageView().then {
    $0.image = Image.vector22
    $0.contentMode = .bottom
  }

  private let viewModel = BookFavoritesViewModel()
  var count = 0
  private var data: BookCaseModel? {
    didSet {
      collectionView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    bind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setNavigationBar(isHidden: false)
    navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    navigationController?.navigationBar.barTintColor = .white
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(didTapAddBookButton))
    navigationItem.rightBarButtonItem?.tintColor = .black
    tabBarController?.tabBar.isHidden = true
  }
}

extension BookFavoritesViewController {
  private func render() {
    view.adds([
      emptyView,
      collectionView
    ])

    emptyView.adds([
      bookImage,
      emptyLabel
    ])

    emptyView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    bookImage.snp.makeConstraints { make in
      make.size.equalTo(16)
      make.centerX.equalTo(self.emptyView)
      make.centerY.equalTo(self.emptyView)
    }

    emptyLabel.snp.makeConstraints { make in
      make.top.equalTo(self.bookImage.snp.bottom).offset(4)
      make.centerX.equalTo(self.emptyView)
    }

    collectionView.delegate = self
    collectionView.dataSource = self
  }
  private func bind() {
    let viewDidLoadPublisher = PublishSubject<Void>()
    let input = BookFavoritesViewModel.Input(viewDidLoadPublisher: viewDidLoadPublisher)
    let output = viewModel.transfrom(input: input)
    output.data
      .drive(onNext: {[weak self] data in
        guard let self = self else { return }
        self.data = data
      })
      .disposed(by: disposeBag)
    viewDidLoadPublisher.onNext(())
  }

  @objc func didTapAddBookButton() {
    let viewController = SearchBookViewController()
    navigationController?.pushViewController(viewController, animated: false)
  }
}

extension BookFavoritesViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if data?.bookcase.count ?? 0 % 3 == 0 {
      return data?.bookcase.count ?? 0 / 3
    } else if data?.bookcase.count ?? 0 > 3 {
      return data?.bookcase.count ?? 0 / 3 + 1
    }
    return 1
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: BookFavoritesShelfCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.collectionView.backgroundView = bookShelfImageView
    cell.rx.binder.onNext(data?.bookcase ?? [])
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 1
  }
}

extension BookFavoritesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: ScreenSize.width, height: 180)
  }
}

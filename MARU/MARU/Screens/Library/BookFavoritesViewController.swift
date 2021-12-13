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
  private let emptyView = EmptyView(
    image: Image.group841?.withRenderingMode(.alwaysTemplate) ?? UIImage(),
    content: """
    모임하고 싶은 책이 아직 없어요.
    +버튼을 눌러 서재를 채워주세요.
    """
  )

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

    emptyView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
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
        if data?.bookcase.count ?? 0 > 0 {
          self.emptyView.isHidden = true
        }
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
    cell.rx.didTapContentView
      .subscribe( onNext: { [weak self] _ in
        guard let self = self else { return }
        let viewController = CreateQuizViewController(
          bookModel: BookModel.init(
            isbn: self.data?.bookcase[indexPath.item].isbn ?? 0,
            title: self.data?.bookcase[indexPath.item].title ?? "",
            author: self.data?.bookcase[indexPath.item].author ?? "",
            imageURL: self.data?.bookcase[indexPath.item].imageURL ?? "",
            category: self.data?.bookcase[indexPath.item].category ?? "",
            hasMyBookcase: true)
        )
        if self.data?.bookcase[indexPath.item].canMakeGroup == true {
          self.navigationController?.pushViewController(viewController, animated: true)
        } else {
          // TODO: - 모임열수없음 팝업 추가
          let targetViewController = JoinLimitViewController()
          targetViewController.modalPresentationStyle = .overCurrentContext
          targetViewController.modalTransitionStyle = .crossDissolve
          self.present(targetViewController, animated: true)
        }

      })
      .disposed(by: cell.disposeBag)
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

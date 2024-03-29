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
    image: Image.autoStories?.withRenderingMode(.alwaysTemplate) ?? UIImage(),
    content: """
    모임하고 싶은 책이 아직 없어요.
    +버튼을 눌러 서재를 채워주세요.
    """
  )

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 0
    layout.sectionInset = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(cell: BookFavoritesCell.self,
                            forCellWithReuseIdentifier: BookFavoritesCell.reuseIdentifier)
    return collectionView
  }()

  private let bookShelfImageView = UIImageView().then {
    $0.image = Image.vector22
    $0.contentMode = .bottom
  }

  private let viewModel = BookFavoritesViewModel()
  var shelfCount = 0
  private var bookShelfData: [BookShelfModel]?
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
    view.add(collectionView) { view in
      view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    view.add(emptyView) { view in
      view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
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
        self.collectionView.reloadData()
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
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: BookFavoritesCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.rx.dataBinder.onNext(data?.bookcase[indexPath.item])
    cell.rx.didTapContentView
      .subscribe( onNext: { [weak self] _ in
        guard
          let self = self,
          let bookcase = self.data?.bookcase[indexPath.item]
        else { return }
        let viewController = CreateQuizViewController(
          bookModel: BookModel.init(
            isbn: bookcase.isbn,
            title: bookcase.title,
            author: bookcase.author,
            imageURL: bookcase.imageURL,
            category: bookcase.category,
            hasMyBookcase: true)
        )
        if bookcase.canMakeGroup == true {
          self.navigationController?.pushViewController(viewController, animated: true)
          return
        }
        // TODO: - 모임열수없음 팝업 추가
        let targetViewController = JoinLimitViewController()
        targetViewController.modalPresentationStyle = .overCurrentContext
        targetViewController.modalTransitionStyle = .crossDissolve
        self.present(targetViewController, animated: true)
      })
      .disposed(by: cell.disposeBag)
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return data?.bookcase.count ?? 0
  }
}

extension BookFavoritesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: (ScreenSize.width - 60) / 3, height: 170)
  }
}

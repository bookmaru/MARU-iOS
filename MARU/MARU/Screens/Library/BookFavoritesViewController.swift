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
  let emptyView = UIView().then {
    $0.backgroundColor = .white
    $0.isHidden = true
  }
  let bookImage = UIImageView().then {
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
  private let viewModel = BookFavoritesViewModel()
  var shelf: Int?
  fileprivate var data: BookCaseModel?
  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    bind()
  }
  // TODO: - 분명히 네비게이션 처리 다른 방법이 있었던 것 같지만 급한 관계로 원래 알던 방식대로 처리를 진행합니다. 여유생기면 고치기
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
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
  func render() {
    view.add(emptyView) { make in
      make.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    emptyView.add(bookImage) { make in
      make.snp.makeConstraints {
        $0.size.equalTo(16)
        $0.centerX.equalTo(self.emptyView)
        $0.centerY.equalTo(self.emptyView)
      }
    }
    emptyView.add(emptyLabel) { make in
      make.snp.makeConstraints {
        $0.top.equalTo(self.bookImage.snp.bottom).offset(4)
        $0.centerX.equalTo(self.emptyView)
      }
    }
    view.add(collectionView) { view in
      view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  func bind() {
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
    self.navigationController?.pushViewController(viewController, animated: false)
  }
}

extension BookFavoritesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: BookFavoritesShelfCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.rx.binder.onNext((data!))
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if data?.bookcase.count ?? 0 % 3 == 0 {
      shelf = data?.bookcase.count ?? 0 / 3
    } else if data?.bookcase.count ?? 0 >= 3 {
      shelf = (data?.bookcase.count ?? 0 / 3) + 1
    } else {
      shelf = 1
    }
    return shelf ?? 0
  }
}

extension BookFavoritesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: ScreenSize.width-40, height: 180)
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // cell Tap Action
  }
}

//
//  MyLibraryViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/01.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class MyLibraryViewController: BaseViewController {

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    // MARK: layout.headerReferenceSize 사용해서도 headerview size 조정 가능
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    collectionView.register(
      MyLibraryHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: MyLibraryHeaderView.reuseIdentifier
    )
    collectionView.register(
      cell: LibraryTitleCell.self,
      forCellWithReuseIdentifier: LibraryTitleCell.reuseIdentifier
    )
    collectionView.register(
      cell: MyLibraryCell.self,
      forCellWithReuseIdentifier: MyLibraryCell.reuseIdentifier
    )
    collectionView.register(
      cell: MyBookCaseCell.self,
      forCellWithReuseIdentifier: MyBookCaseCell.reuseIdentifier
    )
    collectionView.register(
      cell: LibraryDiaryCell.self,
      forCellWithReuseIdentifier: LibraryDiaryCell.reuseIdentifier
    )
    return collectionView
  }()

  private let changeSettingButton = UIBarButtonItem(
    image: Image.group962,
    style: .plain,
    target: self,
    action: nil
  ).then {
    $0.tintColor = .veryLightPink
  }

  private let viewModel = MyLibraryViewModel()
  private var user: User?
  private var data: [Library] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    bind()
    setupNavigation()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    tabBarController?.tabBar.isHidden = false
  }

  private func render() {
    view.add(collectionView) { view in
      view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    collectionView.delegate = self
    collectionView.dataSource = self
  }

  private func bind() {
    let viewDidLoadPublisher = PublishSubject<Void>()
    let input = MyLibraryViewModel.Input(viewDidLoadPublisher: viewDidLoadPublisher)
    let output = viewModel.transform(input: input)

    output.data
      .drive(onNext: { [weak self] data in
        guard let self = self else { return }
        self.data = data
      })
      .disposed(by: disposeBag)

    output.user
      .drive(onNext: { [weak self] user in
        guard let self = self else { return }
        self.user = user
      })
      .disposed(by: disposeBag)

    viewDidLoadPublisher.onNext(())
  }

  private func setupNavigation() {
    navigationItem.rightBarButtonItem = changeSettingButton
    navigationController?.navigationBar.isHidden = false
    guard let navigationBar = navigationController?.navigationBar else { return }
    navigationBar.barTintColor = .white
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true

    changeSettingButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        let viewController = SettingViewController()
        self?.navigationController?.pushViewController(viewController, animated: true)
      })
      .disposed(by: disposeBag)
  }

}

extension MyLibraryViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return data.count
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data[section].count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch data[indexPath.section] {
    case let .title(titleText, isHidden):
      let cell: LibraryTitleCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.rx.addButtonIsHiddenBinder.onNext(isHidden)
      cell.rx.titleBinder.onNext(titleText)
      if titleText == "담아둔 모임" {
        cell.rx.didTapAddButton
          .subscribe(onNext: {
            let viewController = PastMeetingViewController()
            viewController.navigationItem.title = titleText
            self.navigationController?.pushViewController(viewController, animated: true)
          })
          .disposed(by: cell.disposeBag)
      }
      if titleText == "모임하고 싶은 책" {
        cell.addButton.setImage(Image.group1038, for: .normal)
        cell.rx.didTapAddButton
          .subscribe(onNext: {
            let viewController = BookFavoritesViewController()
            viewController.navigationItem.title = titleText
            self.navigationController?.pushViewController(viewController, animated: true)
          })
          .disposed(by: cell.disposeBag)
      }
      if titleText == "내 일기장" {
        cell.rx.didTapAddButton
          .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let viewController = MyDiaryViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
          })
          .disposed(by: cell.disposeBag)
      }
      return cell
    // MARK: - 담아둔 모임
    case let .meeting(keepGroupModel):
      let cell: MyLibraryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      let titleCell: LibraryTitleCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      if keepGroupModel.keepGroup.count == 0 {
        cell.noResultImageView.isHidden = false
        titleCell.addButton.isHidden = true
      } else {
        cell.noResultImageView.isHidden = true
        cell.rx.binder.onNext(keepGroupModel.keepGroup[indexPath.item])
      }
      return cell
    // MARK: - 모임하고 싶은 책
    case let .book(data):
      let cell: MyBookCaseCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      if data.bookcase.count == 0 {
        print("aaaaa")
        cell.noResultImageView.isHidden = false
      } else {
        cell.noResultImageView.isHidden = true
        cell.rx.binder.onNext(data.bookcase[indexPath.item])
      }
      return cell
    // MARK: - 내 일기장
    case let .diary(data):
      let cell: LibraryDiaryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.rx.didTapContentView
        .subscribe(onNext: { [weak self] _ in
          guard let self = self else { return }
          let viewController = DiaryViewController(diaryID: data.diaries[indexPath.item].diaryID)
          self.navigationController?.pushViewController(viewController, animated: true)
        })
        .disposed(by: cell.disposeBag)
      cell.rx.dataBinder.onNext(data.diaries[indexPath.item])
      return cell
    }
  }
}

extension MyLibraryViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {

    return data[indexPath.section].size
  }
  // MARK: - headerview section 처리해주기. size 지정도 필수이다.
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    guard let headerView = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: MyLibraryHeaderView.reuseIdentifier,
      for: indexPath
    ) as? MyLibraryHeaderView,
    let user = user
    else { return UICollectionReusableView() }

    headerView.rx.profileBinder.onNext(user)
    headerView.changeProfileButton.rx.tap
      .subscribe { [weak self] _ in
        guard let self = self else { return }
        let viewController = ProfileChangeViewController()
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
      }
      .disposed(by: headerView.disposeBag)

    return headerView
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForHeaderInSection section: Int) -> CGSize {
    guard section == 0 else { return .zero }
    return CGSize(width: ScreenSize.width, height: 187)
  }
}

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
    //  layout.headerReferenceSize 사용해서도 headerview size 조정 가능
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
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
      cell: LibraryDiaryCell.self,
      forCellWithReuseIdentifier: LibraryDiaryCell.reuseIdentifier
    )
    return collectionView
  }()
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
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: true)
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
}

extension MyLibraryViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    print("total\(data)")
    print("dataCount\(data.count)")
    return data.count
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print("numbOfItemsInSection\(data[section].count)")
    return data[section].count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    print("section\(indexPath.section)")
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
        // 이후에 완성한 뷰로 연결시켜주기
      }
      if titleText == "내 일기장" {
        cell.rx.didTapAddButton
          .subscribe(onNext: {
            // 화면 전환 영역
          })
          .disposed(by: cell.disposeBag)
      }
      return cell
    // MARK: - 담아둔 모임
    case let .meeting(keepGroupModel):
      let cell: MyLibraryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      if keepGroupModel.keepGroup.count == 0 {
        cell.noResultImageView.isHidden = false
      } else {
        cell.noResultImageView.isHidden = true
        cell.rx.binder.onNext(keepGroupModel.keepGroup[indexPath.item])
      }
      return cell
    // MARK: - 모임하고 싶은 책
    case let .book(data):
      let cell: MyBookCaseCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.rx.binder.onNext(data.bookcase[indexPath.item])
      return cell
    // MARK: - 내 일기장
    case let .diary(data):
      let cell: LibraryDiaryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.rx.didTapContentView
        .subscribe(onNext: {
          // 일기 선택 후 -> 화면 전환 영역
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
    // MARK: 이런식으로 옵셔널 처리를 하면... 될거에요
    let user = user
    else { return UICollectionReusableView() }
    headerView.rx.profileBinder.onNext(user)
    // TODO: 강제 옵셔널 처리 해결방법 고민해야함
    headerView.changeSettingButton.rx.tap
      .bind {
        let viewController = SettingViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
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

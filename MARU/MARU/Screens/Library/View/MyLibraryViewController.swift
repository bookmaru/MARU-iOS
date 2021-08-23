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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(MyLibraryHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: MyLibraryHeaderView.reuseIdentifier)
    collectionView.register(cell: LibraryTitleCell.self, forCellWithReuseIdentifier: LibraryTitleCell.reuseIdentifier)
    collectionView.register(cell: MyLibraryCell.self, forCellWithReuseIdentifier: MyLibraryCell.reuseIdentifier)
    collectionView.register(cell: LibraryDiaryCell.self, forCellWithReuseIdentifier: LibraryDiaryCell.reuseIdentifier)
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
    let output = viewModel.transform(input: MyLibraryViewModel.Input(viewDidLoadPublisher: viewDidLoadPublisher))
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
    return data.count
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data[section].count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch data[indexPath.section] {
    case let .title(titleText, isHidden):
      let cell: LibraryTitleCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      if titleText == "모임하고 싶은 책" {
        cell.addButton.setImage(Image.group1038, for: .normal)
      }
      cell.rx.didTapAddButton
        .subscribe(onNext: {
          // 화면 전환 영역
        })
        .disposed(by: cell.disposeBag)
      cell.rx.addButtonIsHiddenBinder.onNext(isHidden)
      cell.rx.titleBinder.onNext(titleText)
      return cell
    // MARK: - 담아둔 모임
    case let .meeting(keepGroupModel):
      let cell: MyLibraryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.awakeFromNib()
      cell.rx.binder.onNext(keepGroupModel.keepGroup[indexPath.item])
      if keepGroupModel.keepGroup.count == 0 {
        cell.noResultImageView.isHidden = false
      } else {
        cell.noResultImageView.isHidden = true
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
      print("3트\(data.diaries[indexPath.item])")
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
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    if let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: MyLibraryHeaderView.reuseIdentifier, for: indexPath) as? MyLibraryHeaderView {
      headerView.rx.profileBinder.onNext(user!)
      return headerView
    }
    return UICollectionReusableView()
  }
}

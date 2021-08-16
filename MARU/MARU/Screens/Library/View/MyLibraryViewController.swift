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
    collectionView.register(MyLibraryHeaderView.self, forSupplementaryViewOfKind:
                              MyLibraryHeaderView.sectionHeaderElementKind,
                            withReuseIdentifier: MyLibraryHeaderView.reuseIdentifier)
    collectionView.register(cell: LibraryTitleCell.self)
    collectionView.register(cell: MyLibraryCell.self)
    collectionView.register(cell: LibraryDiaryCell.self)
    return collectionView
  }()
  private let viewModel = MyLibraryViewModel()
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

      cell.rx.didTapAddButton
        .subscribe(onNext: {

        })
        .disposed(by: cell.disposeBag)
      cell.rx.addButtonIsHiddenBinder.onNext(isHidden)
      cell.rx.titleBinder.onNext(titleText)

      return cell

    case let .meeting(data):

      let cell: MyLibraryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

      cell.rx.binder.onNext(data)

      return cell

    case let .diary(data):

      let cell: LibraryDiaryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

      cell.rx.didTapContentView
        .subscribe(onNext: {

        })
        .disposed(by: cell.disposeBag)

      cell.rx.dataBinder.onNext([data])

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
}

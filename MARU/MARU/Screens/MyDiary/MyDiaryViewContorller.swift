//
//  MyDiaryViewContorller.swift
//  MARU
//
//  Created by 오준현 on 2021/09/19.
//

import UIKit

import RxCocoa
import RxSwift

final class MyDiaryViewController: BaseViewController {

  override var hidesBottomBarWhenPushed: Bool {
    get { navigationController?.topViewController == self }
    set { super.hidesBottomBarWhenPushed = newValue }
  }

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.register(cell: MyDiaryCell.self)
    return collectionView
  }()

  private let viewModel = MyDiaryViewModel()

  override init() {
    super.init()
    setupCollectionView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }

  private func setupCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }

  private func render() {
    view.add(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension MyDiaryViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return .zero
  }
}

extension MyDiaryViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: MyDiaryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 0
  }
}

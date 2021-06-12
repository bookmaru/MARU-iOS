//
//  OnboardingViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/06/05.
//

import UIKit

import SnapKit

final class OnboardingViewController: BaseViewController {
  typealias Cell = OnboardingCollectionViewCell
  typealias LoginCell = OnboardingLoginCollectionViewCell

  private let collectionView: UICollectionView = {
    let size = UIScreen.main.bounds
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.itemSize = CGSize(width: size.width, height: size.height - 174)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(cell: Cell.self)
    collectionView.register(cell: LoginCell.self)
    return collectionView
  }()

  private let guide: [String] = [
    """
    함께 나아가는
    독서 문화 공간 마루
    """,
    """
    소통하며 쌓아가는
    독서의 즐거움
    """,
    """
    언제 어디서든
    책과 사람이 이어지는 공간
    """
  ]
  private let subGuide: [String] = [
    """
    국내 최초 온라인 독서 토론 플랫폼으로써
    책을 통해 마음을 잇는 법을 제시합니다.
    """,
    """
    독서 후 여운을 사람들과 함께 나누며
    진정한 자아를 찾아보세요.
    """
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }
}

extension OnboardingViewController {
  private func render() {
    view.add(collectionView)
    collectionView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(78)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.equalToSuperview().offset(-96)
    }
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {}

extension OnboardingViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 3
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = indexPath.item
    if item == 2 {
      let cell: LoginCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      return cell
    } else {
      let cell: Cell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.bind(guide: guide[item], subGuide: subGuide[item])
      return cell
    }
  }
}

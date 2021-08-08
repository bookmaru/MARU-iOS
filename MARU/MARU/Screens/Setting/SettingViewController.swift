//
//  SettingViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/08/06.
//

import UIKit

final class SettingViewController: BaseViewController {

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: ScreenSize.width, height: 49)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cell: SettingCollectionViewCell.self)
    return collectionView
  }()

  private let row: [String] = ["공지사항", "서비스 이용약관", "오픈소스 라이선스", "로그아웃", "탈퇴하기"]

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }

  private func render() {
    title = "환경설정"
    view.add(collectionView) { view in
      view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

extension SettingViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {

  }
}

extension SettingViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return row.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SettingCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.separatorViewRow(row: indexPath.item)
    cell.titleLabel(title: row[indexPath.item])
    return cell
  }
}

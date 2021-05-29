//
//  MainViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/04/03.
//

import UIKit

import RxSwift
import RxCocoa

final class MainViewController: BaseViewController {

  private let mainCollectionView = MainViewCollectionView().then {
    $0.backgroundColor = .white
    // Header
    $0.register(SectionHeader.self,
                forSupplementaryViewOfKind: SectionHeader.sectionHeaderElementKind,
                withReuseIdentifier: SectionHeader.reuseIdentifier)
    $0.register(MainHeaderCell.self,
                forCellWithReuseIdentifier: MainHeaderCell.reuseIdentifier)
    $0.register(PopularMeetingCell.self,
                forCellWithReuseIdentifier: PopularMeetingCell.reuseIdentifier)
    $0.register(NewMeetingCell.self,
                forCellWithReuseIdentifier: NewMeetingCell.reuseIdentifier )
  }
  // MARK: - Variable & Properties

  let screenSize = UIScreen.main.bounds.size
  private let style: UIStatusBarStyle = .lightContent
//  private let bag = DisposeBag()
//  let viewModel = MainViewModel()

  override var preferredStatusBarStyle: UIStatusBarStyle {
          return self.style
      }

  override func viewDidLoad() {
    super.viewDidLoad()
    mainCollectionView.contentInsetAdjustmentBehavior = .never
    mainCollectionView.delegate = self
    mainCollectionView.dataSource = self
    applyLayout()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: true)
  }
}

extension MainViewController {
  private func applyLayout() {

    mainCollectionView.contentInsetAdjustmentBehavior = .never
    mainCollectionView.delegate = self
    mainCollectionView.dataSource = self

    view.add(mainCollectionView)

    mainCollectionView.snp.makeConstraints { (make) in
      make.top.equalTo(view.snp.top).inset(0)
      make.leading.equalTo(view.snp.leading).inset(0)
      make.trailing.equalTo(view.snp.trailing).inset(0)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(0)
    }
  }
}

extension MainViewController: SearchTextFieldDelegate, UITextFieldDelegate {
  func tapTextField() {
    let target = MorePopularViewController()
    view.hideKeyboard()
    self.present(target, animated: true, completion: nil)
  }
}
extension MainViewController: ButtonDelegate {
  func tapButton() {
    let target = MorePopularViewController()
    self.navigationController?.pushViewController(target, animated: true)
  }
}

extension MainViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    switch indexPath.section {
    case 1:
      guard let header =
              mainCollectionView.dequeueReusableSupplementaryView(ofKind: SectionHeader.sectionHeaderElementKind,
                                                                  withReuseIdentifier: SectionHeader.reuseIdentifier,
                                                                  for: indexPath) as? SectionHeader else {
        return UICollectionReusableView() }
      header.setupText(text: "지금 가장 인기 많은 모임은?")
      header.hideButton(isHidden: true)
      return header

    case 2:
      guard let header =
              mainCollectionView.dequeueReusableSupplementaryView(ofKind: SectionHeader.sectionHeaderElementKind,
                                                                  withReuseIdentifier: SectionHeader.reuseIdentifier,
                                                                  for: indexPath) as? SectionHeader else {
        return UICollectionReusableView() }
      header.setupText(text: "지금 새로 나온 모임")
      header.hideButton(isHidden: false)
      header.delegate = self
      return header

    default:
      return UICollectionReusableView()
    }
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 8
    case 2:
      return 10
    default:
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.section {
    case 0:
      guard let cell =
              mainCollectionView.dequeueReusableCell(withReuseIdentifier: MainHeaderCell.reuseIdentifier,
                                         for: indexPath) as? MainHeaderCell else {
        return UICollectionViewCell() }
      cell.searchBar.delegate = self
      return cell

    case 1:
      guard let cell =
              mainCollectionView.dequeueReusableCell(withReuseIdentifier: PopularMeetingCell.reuseIdentifier,
                                         for: indexPath) as? PopularMeetingCell else {
        return UICollectionViewCell() }
      return cell

    case 2:
      guard let cell =
              mainCollectionView.dequeueReusableCell(withReuseIdentifier: NewMeetingCell.reuseIdentifier,
                                                     for: indexPath) as? NewMeetingCell else {
        return UICollectionViewCell() }
      return cell

    default:
      return UICollectionViewCell()
    }

  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 3
  }

}

extension MainViewController: UICollectionViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < 0 {
      scrollView.isScrollEnabled = false
      scrollView.bounds = view.bounds
    }
    scrollView.isScrollEnabled = true
  }

}

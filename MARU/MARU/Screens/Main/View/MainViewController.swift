//
//  MainViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/04/03.
//

import UIKit

import RxSwift
import RxCocoa
import RxViewController

final class MainViewController: BaseViewController {

  private var collectionView: UICollectionView! = nil
  private let screenSize = UIScreen.main.bounds.size
  private let style: UIStatusBarStyle = .lightContent
  private let disposBag = DisposeBag()
  private let viewModel = MainViewModel()

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return self.style
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureHirarchy()
    bind()
//    NetworkService.shared.home.getPopular()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: true)
  }
}
extension MainViewController {
  private func bind() {
    print("Call bind() in MainVC ")
    let firstLoad = rx.viewWillAppear
      .take(1)
      .map {_ in ()}

    let reload = collectionView.refreshControl?.rx
      .controlEvent(.valueChanged)
      .map { _ in () } ?? Observable.just(())

    let load = Observable.merge([firstLoad, reload])

    let input = MainViewModel.Input(fetchPopularMeeting: load)
    let output = viewModel.transform(input: input)
    output.allPopularMeetings
      .subscribe(onNext: {
        print($0)
      })
      .disposed(by: disposeBag)
  }
}
  /// - TAG: View Layout
extension MainViewController {
  private func configureHirarchy() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .white
    collectionView.register(SectionHeader.self,
                forSupplementaryViewOfKind: SectionHeader.sectionHeaderElementKind,
                withReuseIdentifier: SectionHeader.reuseIdentifier)
    collectionView.register(MainHeaderCell.self,
                forCellWithReuseIdentifier: MainHeaderCell.reuseIdentifier)
    collectionView.register(PopularMeetingCell.self,
                forCellWithReuseIdentifier: PopularMeetingCell.reuseIdentifier)
    collectionView.register(MeetingListCell.self,
                forCellWithReuseIdentifier: MeetingListCell.reuseIdentifier)

    view.add(collectionView)

    collectionView.snp.makeConstraints { (make) in
      make.top.equalTo(view.snp.top).inset(0)
      make.leading.equalTo(view.snp.leading).inset(0)
      make.trailing.equalTo(view.snp.trailing).inset(0)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(0)
    }
  }
}

extension MainViewController: SearchTextFieldDelegate, UITextFieldDelegate {
  func tapTextField() {
    let targetViewController = RecentSearchViewController()
    resignFirstResponder()
    view.hideKeyboard()
    self.navigationController?.pushViewController(targetViewController, animated: true)
  }
}
extension MainViewController: ButtonDelegate {
  func didPressButtonInHeader(_ tag: Int) {
    let targetViewController = MoreNewViewController()
    targetViewController.navigationItem.title = "지금 새로 나온 모임"
    self.navigationController?.pushViewController(targetViewController, animated: true)
  }
}
extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    switch indexPath.section {
    case 1:
      guard let header =
              collectionView.dequeueReusableSupplementaryView(ofKind: SectionHeader.sectionHeaderElementKind,
                                                                  withReuseIdentifier: SectionHeader.reuseIdentifier,
                                                                  for: indexPath) as? SectionHeader else {
        return UICollectionReusableView() }
      header.setupText(text: "지금 가장 인기 많은 모임은?")
      header.hideMoveButton(isHidden: true)
      return header

    case 2:
      guard let header =
              collectionView.dequeueReusableSupplementaryView(ofKind: SectionHeader.sectionHeaderElementKind,
                                                                  withReuseIdentifier: SectionHeader.reuseIdentifier,
                                                                  for: indexPath) as? SectionHeader else {
        return UICollectionReusableView() }
      header.setupText(text: "지금 새로 나온 모임")
      header.hideMoveButton(isHidden: false)
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
              collectionView.dequeueReusableCell(withReuseIdentifier: MainHeaderCell.reuseIdentifier,
                                                     for: indexPath) as? MainHeaderCell else {
        return UICollectionViewCell() }
      cell.searchBar.delegate = self
      return cell

    case 1:
      guard let cell =
              collectionView.dequeueReusableCell(withReuseIdentifier: PopularMeetingCell.reuseIdentifier,
                                                     for: indexPath) as? PopularMeetingCell else {
        return UICollectionViewCell() }
      return cell

    case 2:
      guard let cell =
              collectionView.dequeueReusableCell(withReuseIdentifier: MeetingListCell.reuseIdentifier,
                                                     for: indexPath) as? MeetingListCell else {
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
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      break

    case 1:
      let targetViewController = MorePopularViewController()
      guard let cell = collectionView.cellForItem(at: indexPath) as? PopularMeetingCell else { return }
      targetViewController.navigationItem.title = cell.name()
      self.navigationController?.pushViewController(targetViewController, animated: true)

    case 2:
      break

    default:
      break
    }
  }

  // MARK: - Sticky Header.
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < 0 {
      scrollView.isScrollEnabled = false
      scrollView.bounds = view.bounds
    }
    scrollView.isScrollEnabled = true
  }
}
  /// - TAG: Collection View Layout
extension MainViewController {
  private func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in

      if sectionNumber == 0 {
        return self.generateFirstSection()
      } else if sectionNumber == 1 {
        return self.generateSecondSection()
      } else {
        return self.generateThirdSection()
      }
    }
  }
  private func generateFirstSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.edgeSpacing = .none

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .absolute(screenSize.height * 0.340))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])
    group.edgeSpacing = .none

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    return section
  }

  private func generateSecondSection() -> NSCollectionLayoutSection {
    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .estimated(screenSize.width * 0.893),
                                                  heightDimension: .estimated(36))
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: SectionHeader.sectionHeaderElementKind, alignment: .top)

    let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(95),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(8),
                                                     top: nil,
                                                     trailing: .fixed(8),
                                                     bottom: nil)

    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(screenSize.width * 0.893),
                                           heightDimension: .estimated(180))

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
    section.orthogonalScrollingBehavior = .continuous
    section.boundarySupplementaryItems = [sectionHeader]
    return section
  }

  private func generateThirdSection() -> NSCollectionLayoutSection {
    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .estimated(screenSize.width * 0.893),
                                                  heightDimension: .estimated(36))
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: SectionHeader.sectionHeaderElementKind, alignment: .top)

    let section = MaruListCollectionViewLayout.createSection()
    section.boundarySupplementaryItems = [sectionHeader]
    return section
  }

}

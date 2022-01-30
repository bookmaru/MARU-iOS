//
//  MainViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/04/03.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class MainViewController: BaseViewController {

  private var collectionView: UICollectionView! = nil
  private let screenSize = UIScreen.main.bounds.size
  private let style: UIStatusBarStyle = .lightContent
  private let disposBag = DisposeBag()
  private let viewModel = MainViewModel()
  private var popularBooks: [BookModel] = []
  private var newMeetings: [MeetingModel] = []

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return self.style
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    applyBackGesture()
    configureHirarchy()
    bind()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: true)
    tabBarController?.tabBar.isHidden = false
  }
}
/// - Tag: Apply Back Gesture
extension MainViewController: UIGestureRecognizerDelegate {
  private func applyBackGesture() {
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    navigationController?.interactivePopGestureRecognizer?.delegate = self
  }
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return true
  }
}
extension MainViewController {

  private func bind() {
    let firstLoad = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in () }

    let input = MainViewModel.Input(fetch: firstLoad)
    let output = viewModel.transform(input: input)

    output.allPopularMeetings
      .subscribe(onNext: { [weak self] popularBooks in
        guard let self = self else { return }
        self.popularBooks = popularBooks
        self.collectionView.reloadSections(IndexSet(integer: 1))
      })
      .disposed(by: disposeBag)

    output.allNewMeetings
      .subscribe(onNext: { [weak self] newMeetings in
        guard let self = self else { return }
        self.newMeetings = newMeetings
        self.collectionView.reloadSections(IndexSet(integer: 2))
      })
      .disposed(by: disposBag)

    output.errorMessage
      .subscribe(onNext: {
        print($0)
      })
      .disposed(by: disposBag)
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
    collectionView.register(
      SectionHeader.self,
      forSupplementaryViewOfKind: SectionHeader.sectionHeaderElementKind,
      withReuseIdentifier: SectionHeader.reuseIdentifier
    )
    collectionView.register(
      MainHeaderCell.self,
      forCellWithReuseIdentifier: MainHeaderCell.reuseIdentifier
    )
    collectionView.register(
      BookCell.self,
      forCellWithReuseIdentifier: BookCell.reuseIdentifier
    )
    collectionView.register(
      MeetingListCell.self,
      forCellWithReuseIdentifier: MeetingListCell.reuseIdentifier
    )

    view.add(collectionView)

    collectionView.snp.makeConstraints { (make) in
      make.top.equalTo(view.snp.top).inset(0)
      make.leading.equalTo(view.snp.leading).inset(0)
      make.trailing.equalTo(view.snp.trailing).inset(0)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(0)
    }
  }
}
  /// - TAG: Tap Text Field Delegate.
extension MainViewController: SearchTextFieldDelegate, UITextFieldDelegate {
  func tapTextField() {
    let targetViewController = RecentSearchViewController()
    resignFirstResponder()
    view.hideKeyboard()
    navigationController?.pushViewController(targetViewController, animated: true)
  }
}
  /// - TAG: Left Header Button Tap Action
extension MainViewController: ButtonDelegate {
  func didPressButtonInHeader(_ tag: Int) {
    let targetViewController = MoreNewViewController()
    targetViewController.navigationItem.title = "지금 새로 나온 모임"
    navigationController?.pushViewController(targetViewController, animated: true)
  }
}
extension MainViewController: UICollectionViewDataSource {
  /// - TAG: Header Info.
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    switch indexPath.section {
    case 1:
      guard let header = collectionView.dequeueReusableSupplementaryView(
              ofKind: SectionHeader.sectionHeaderElementKind,
              withReuseIdentifier: SectionHeader.reuseIdentifier,
              for: indexPath
      ) as? SectionHeader else { break }
      header.setupText(text: "가장 모임이 많은 책은?")
      header.hideMoveButton(isHidden: true)
      return header

    case 2:
      guard let header = collectionView.dequeueReusableSupplementaryView(
              ofKind: SectionHeader.sectionHeaderElementKind,
              withReuseIdentifier: SectionHeader.reuseIdentifier,
              for: indexPath
      ) as? SectionHeader else { break }
      header.setupText(text: "지금 새로 나온 모임")
      header.hideMoveButton(isHidden: false)
      header.delegate = self
      return header

    default:
      break
    }
    return UICollectionReusableView()
  }
  /// - TAG: Item Number
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return popularBooks.count
    case 2:
      return newMeetings.count
    default:
      return 0
    }
  }
  /// - TAG: Cell Info
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: MainHeaderCell.reuseIdentifier,
              for: indexPath
      ) as? MainHeaderCell else { break }
      cell.searchBar.delegate = self
      return cell

    case 1:
      guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: BookCell.reuseIdentifier,
              for: indexPath
      ) as? BookCell else { break }
      cell.bind(popularBooks[indexPath.item])
      return cell

    case 2:
      guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: MeetingListCell.reuseIdentifier,
              for: indexPath
      ) as? MeetingListCell else { break  }
      cell.bind(newMeetings[indexPath.item])
      return cell

    default:
      break
    }
    return UICollectionViewCell()
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 3
  }
}

extension MainViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch indexPath.section {
    case 1:
      guard let cell = collectionView.cellForItem(at: indexPath) as? BookCell,
            let isbn = cell.getISBN() else { return }
      let targetViewController = MorePopularViewController(isbn: isbn)
      targetViewController.navigationItem.title = cell.name()
      navigationController?.pushViewController(targetViewController, animated: true)
    case 2:
      guard let cell = collectionView.cellForItem(at: indexPath) as? MeetingListCell,
            let groupID = Int(cell.getDiscussionGroupID()) else { return }
      let targetViewController = JoinViewController(groupID: groupID)
      navigationController?.pushViewController(targetViewController, animated: true)
    default:
      break
    }
  }

  /// - TAG: Sticky Header
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < 0 {
      scrollView.isScrollEnabled = false
      scrollView.bounds = view.bounds
    }
    scrollView.isScrollEnabled = true
  }
}
  // MARK: - Collection View Layout
extension MainViewController {
  private func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { sectionNumber, _ -> NSCollectionLayoutSection? in
      if sectionNumber == 0 {
        return self.generateFirstSection()
      }
      if sectionNumber == 1 {
        return self.generateSecondSection()
      }
      return self.generateThirdSection()
    }
  }

  private func generateFirstSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.edgeSpacing = .none

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .absolute(screenSize.height * 0.340)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])
    group.edgeSpacing = .none

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    return section
  }

  private func generateSecondSection() -> NSCollectionLayoutSection {
    let headerFooterSize = NSCollectionLayoutSize(
      widthDimension: .estimated(screenSize.width * 0.893),
      heightDimension: .estimated(36)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: SectionHeader.sectionHeaderElementKind,
      alignment: .top
    )

    let itemSize = NSCollectionLayoutSize(
      widthDimension: .absolute(95),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
      leading: .fixed(8),
      top: nil,
      trailing: .fixed(8),
      bottom: nil
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .estimated(screenSize.width * 0.893),
      heightDimension: .estimated(180)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
    section.orthogonalScrollingBehavior = .continuous
    section.boundarySupplementaryItems = [sectionHeader]
    return section
  }

  private func generateThirdSection() -> NSCollectionLayoutSection {
    let headerFooterSize = NSCollectionLayoutSize(
      widthDimension: .estimated(screenSize.width * 0.893),
      heightDimension: .estimated(36)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: SectionHeader.sectionHeaderElementKind,
      alignment: .top
    )
    let section = MaruListCollectionViewLayout.createSection()
    section.boundarySupplementaryItems = [sectionHeader]
    return section
  }

}

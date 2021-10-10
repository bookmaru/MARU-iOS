//
//  MeetViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/04/03.
//

import UIKit

import RxCocoa
import RxSwift
import Then

final class MeetViewController: BaseViewController {
  typealias ViewModel = MeetViewModel

  private let guideImageView = UIImageView().then {
    $0.image = UIImage(named: "bookImgBlack")
  }

  private let guideLabel = UILabel().then {
    $0.font = .boldSystemFont(ofSize: 20)
    $0.numberOfLines = 2
    $0.text = """
    사람들과 함께
    책장을 넘겨보세요.
    """
  }

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 0, left: 42, bottom: 0, right: 42)
    layout.minimumLineSpacing = 28
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.decelerationRate = .fast
    collectionView.isPagingEnabled = false
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(MeetCollectionViewCell.self,
                            forCellWithReuseIdentifier: MeetCollectionViewCell.reuseIdentifier)
    collectionView.register(EmptyMeetCollectionViewCell.self,
                            forCellWithReuseIdentifier: EmptyMeetCollectionViewCell.reuseIdentifier)
    collectionView.layer.masksToBounds = false
    return collectionView
  }()

  private let pageControl = UIPageControl().then {
    $0.currentPageIndicatorTintColor = .mainBlue
    $0.pageIndicatorTintColor = .veryLightPinkThree
    $0.numberOfPages = 3
  }

  private let viewModel = MeetViewModel()

  private var data: [MeetCase] = [] {
    didSet {
      collectionView.reloadData()
      pageControl.numberOfPages = data.count
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    layout()
    bind()
    setupCollectionView()
    setNavigation()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    tabBarController?.tabBar.isHidden = false
    navigationItem.title = ""
  }

  private func setNavigation() {
    guard let navigationBar = navigationController?.navigationBar else { return }
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
    navigationBar.tintColor = .black
  }
}

extension MeetViewController {
  private func layout() {
    view.add(collectionView) {
      $0.rx.setDelegate(self)
        .disposed(by: self.disposeBag)
    }
    view.add(guideImageView)
    view.add(guideLabel)
    view.add(pageControl)
    guideImageView.snp.makeConstraints {
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.width.height.equalTo(28)
    }
    guideLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(40)
      $0.top.equalTo(guideImageView.snp.bottom).offset(14)
    }
    collectionView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(guideLabel.snp.bottom).offset(31)
      $0.height.equalTo(421/812 * view.frame.height)
    }
    pageControl.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalTo(collectionView.snp.bottom).offset(18)
    }
  }

  private func bind() {
    let viewDidLoad = rx.methodInvoked(#selector(UIViewController.viewWillAppear))
      .map { _ in }
    let input = ViewModel.Input(viewDidLoadPublisher: viewDidLoad)
    let output = viewModel.transform(input: input)

    output.group
      .drive(onNext: { [weak self] response in
        guard let self = self else { return }
        self.data = response
      })
      .disposed(by: disposeBag)
  }

  private func setupCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

extension MeetViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offSet = scrollView.contentOffset.x
    let width = scrollView.frame.width
    let horizontalCenter = width / 2

    pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
  }

  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    let cellWidthIncludeSpacing = view.frame.width - 54
    var offset = targetContentOffset.pointee
    let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludeSpacing
    let roundedIndex: CGFloat = round(index)
    offset = CGPoint(x: roundedIndex * cellWidthIncludeSpacing - scrollView.contentInset.left,
                     y: scrollView.contentInset.top)
    targetContentOffset.pointee = offset
  }
}

extension MeetViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch data[indexPath.item] {

    case .empty:
      let cell: EmptyMeetCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

      return cell

    case .meet(let group):
      let cell: MeetCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

      cell.rx.dataBinder.onNext(group)

      return cell
    }
  }
}

extension MeetViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch data[indexPath.item] {
    case .empty:
      let viewController = ChatViewController(roomID: 1, title: "")
      navigationController?.pushViewController(viewController, animated: true)
    case .meet(let group):
      let viewController = ChatViewController(roomID: group.discussionGroupID, title: group.title)
      navigationController?.pushViewController(viewController, animated: true)
    }
  }
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: view.frame.width - 82, height: collectionView.frame.height)
  }
}

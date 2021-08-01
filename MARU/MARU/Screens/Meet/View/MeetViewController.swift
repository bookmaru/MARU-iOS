//
//  MeetViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/04/03.
//

import UIKit

import Then
import RxSwift
import RxCocoa

final class MeetViewController: BaseViewController {

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

  private let viewModel: MeetViewModel = {
    let viewModel = MeetViewModel()

    return viewModel
  }()

  private var data: Observable<[String]> = .just(["", "", ""])

  override func viewDidLoad() {
    super.viewDidLoad()

    layout()
    bind(reactor: viewModel)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.navigationBar.isHidden = true
    tabBarController?.tabBar.isHidden = false
  }
}

extension MeetViewController {
  func layout() {
    view.add(collectionView) {
      $0.rx.setDelegate(self)
        .disposed(by: self.disposeBag)
    }
    view.add(guideImageView)
    view.add(guideLabel)
    view.add(pageControl)
    guideImageView.snp.makeConstraints {
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(62.9)
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

  func bind(reactor: MeetViewModel) {
    data.bind(to: collectionView.rx.items) { collectionView, item, model -> UICollectionViewCell in
      let indexPath = IndexPath(item: item, section: 0)
      let cell: EmptyMeetCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      print(model)
      return cell
    }.disposed(by: disposeBag)

    collectionView.rx
      .itemSelected
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        let viewController = ChatViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
      }).disposed(by: disposeBag)
  }
}

extension MeetViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offSet = scrollView.contentOffset.x
    let width = scrollView.frame.width
    let horizontalCenter = width / 2

    pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                 withVelocity velocity: CGPoint,
                                 targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let cellWidthIncludeSpacing = view.frame.width - 54
    var offset = targetContentOffset.pointee
    let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludeSpacing
    let roundedIndex: CGFloat = round(index)
    offset = CGPoint(x: roundedIndex * cellWidthIncludeSpacing - scrollView.contentInset.left,
                     y: scrollView.contentInset.top)
    targetContentOffset.pointee = offset
  }
}

extension MeetViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width - 82, height: collectionView.frame.height)
  }
}

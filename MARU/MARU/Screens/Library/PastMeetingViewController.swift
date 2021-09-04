//
//  PastMeetingViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/29.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class PastMeetingViewController: BaseViewController {
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(cell: PastMeetingCell.self, forCellWithReuseIdentifier: PastMeetingCell.reuseIdentifier)
    return collectionView
  }()
  private let viewModel = PastMeetingViewModel()
  private var data: KeepGroupModel?
  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    bind()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: false)
    navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    navigationController?.navigationBar.barTintColor = .white
    tabBarController?.tabBar.isHidden = true
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
    let input = PastMeetingViewModel.Input(viewDidLoadPublisher: viewDidLoadPublisher)
    let output = viewModel.transfrom(input: input)

    output.data
      .drive(onNext: {[weak self] data in
        guard let self = self else { return }
        self.data = data
      })
      .disposed(by: disposeBag)

    viewDidLoadPublisher.onNext(())
  }
}

extension PastMeetingViewController: UICollectionViewDataSource {

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return data?.keepGroup.count ?? 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: PastMeetingCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    // MARK: 준현 - 여기서 isLeader값을 cell 안으로 넣어줘서 처리해도 좋을거같아요!
    if data?.keepGroup[indexPath.item].isLeader == true {
      cell.rx.dataBinder.onNext((data?.keepGroup[indexPath.item]))
      cell.rx.didTapEvaluateButton
        .subscribe(onNext: {
          // 방장이 아닌 경우에는 방장 평가하도록 처리
        })
        .disposed(by: cell.disposeBag)
    } else {
      cell.evaluateButton.isHidden = false
      cell.rx.dataBinder.onNext((data?.keepGroup[indexPath.item])!)
      cell.rx.didTapEvaluateButton
        .subscribe(onNext: {
          // 방장이 아닌 경우에는 방장 평가하도록 처리
        })
        .disposed(by: cell.disposeBag)
    }
    return cell
  }
}

extension PastMeetingViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: ScreenSize.width-40, height: 145)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    // cell tap action
  }
}

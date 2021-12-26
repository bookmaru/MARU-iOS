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
  private let emptyView = EmptyView(
    image: Image.group841?.withRenderingMode(.alwaysTemplate) ?? UIImage(),
    content: """
    담아둔 모임이 아직 없어요.
    모임을 진행하고 담아보세요.
    """
  )
  private let viewModel = PastMeetingViewModel()

  private var data: KeepGroupModel? {
    didSet {
      collectionView.reloadData()
    }
  }

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
    bind()
  }

  private func render() {
    view.add(collectionView) { view in
      view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    view.add(emptyView) { view in
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
        if data?.keepGroup.count ?? 0 > 0 {
          self.emptyView.isHidden = true
        }
        self.data = data
        self.collectionView.reloadData()
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
    // 방장인 경우에는 평가 금지 팝업 화면 등장
    cell.rx.dataBinder.onNext((data?.keepGroup[indexPath.item]))
    cell.rx.didTapEvaluateButton
      .subscribe(onNext: {  viewController in
        let viewController = viewController
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: false, completion: nil)
      })
      .disposed(by: cell.disposeBag)
    if data?.keepGroup[indexPath.item].leaderScore ?? -1 > 0 {
      cell.evaluateButton.isHidden = true
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

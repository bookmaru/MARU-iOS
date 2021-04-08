//
//  MeetViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/04/03.
//

import UIKit

final class MeetViewController: BaseViewController {

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    return collectionView
  }()

  private let viewModel: MeetViewModel = {
    let viewModel = MeetViewModel()

    return viewModel
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    layout()
    bind(reactor: viewModel)
  }
}

extension MeetViewController {
  func layout() {
    view.add(collectionView) {
      $0.rx.setDelegate(self)
        .disposed(by: self.disposeBag)
      $0.snp.makeConstraints {
        $0.edges.equalTo(self.view.safeAreaLayoutGuide)
      }
    }
  }

  func bind(reactor: MeetViewModel) {
//    reactor.state.map {
//      $0.data
//    }.distinctUntilChanged()
    
  }
}

extension MeetViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 100, height: 100)
  }
}

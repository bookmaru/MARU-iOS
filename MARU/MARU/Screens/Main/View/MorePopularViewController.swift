//
//  MorePopularViewController.swift
//  MARU
//
//  Created by psychehose on 2021/06/30.
//

import UIKit

import RxSwift
import RxCocoa

class MorePopularViewController: BaseViewController {

  enum Section {
    case main
  }

  private var collectionView: UICollectionView! = nil
  private var dataSource: UICollectionViewDiffableDataSource<Section, MeetingModel>! = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    configureHierarchy()
    bind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: false)
    tabBarController?.tabBar.isHidden = true
    navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    navigationController?.navigationBar.barTintColor = .white
  }

  private func bind() {
    let viewTrigger = rx.sentMessage(#selector(UIViewController.viewWillAppear(_: )))
      .map { _ in () }

    _ = viewTrigger
      .flatMap { [self] in NetworkService.shared.groupSearch.search(queryString: navigationItem.title ?? "") }
      .map { response -> BaseReponseType<Groups> in
        guard 200 ..< 300 ~= response.status else {
          throw NSError.init(domain: "Detect Error in Fetching Search meetings",
                             code: -1, userInfo: nil)
        }
        return response
      }
      .map { $0.data?.groups.map { MeetingModel($0)} }
      .map { meetingModel -> [MeetingModel] in
        guard let meetingModel = meetingModel else { return [] }
        return meetingModel
      }
      .asDriver(onErrorJustReturn: [])
      .drive { [self] in
        configureDataSource($0)
      }
      .disposed(by: disposeBag)
  }
}

extension MorePopularViewController {
  /// - TAG: Layout
  private func configureHierarchy() {
    collectionView = UICollectionView(frame: .zero,
                                      collectionViewLayout: MaruListCollectionViewLayout.createLayout())
    view.add(collectionView) {
      $0.snp.makeConstraints { make in
        make.top.equalToSuperview().inset(15)
        make.bottom.equalToSuperview()
        make.leading.equalToSuperview()
        make.trailing.equalToSuperview()
      }
    }

    collectionView.backgroundColor = .clear
    collectionView.delegate = self
  }

  private func configureDataSource(_ items: [MeetingModel]) {
    let cellRegistration = UICollectionView
      .CellRegistration<MeetingListCell, MeetingModel> {cell, _, meetingModel in
        cell.bind(meetingModel)
      }

    dataSource = UICollectionViewDiffableDataSource<Section, MeetingModel>(
    collectionView: collectionView,
      cellProvider: { collectionView, indexPath, identifier in
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                            for: indexPath,
                                                            item: identifier)
      })

    var snapshot = NSDiffableDataSourceSnapshot<Section, MeetingModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
extension MorePopularViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let meetingModel = dataSource.itemIdentifier(for: indexPath) else {
      return
    }
    // 여기에 화면전환
    print(meetingModel.discussionGroupID)
  }
}

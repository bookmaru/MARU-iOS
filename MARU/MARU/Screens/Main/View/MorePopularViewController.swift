//
//  MorePopularViewController.swift
//  MARU
//
//  Created by psychehose on 2021/06/30.
//

import UIKit

import RxCocoa
import RxSwift

final class MorePopularViewController: BaseViewController {

  enum Section {
    case main
  }

  private var collectionView: UICollectionView! = nil
  private var dataSource: UICollectionViewDiffableDataSource<Section, MeetingModel>! = nil
  private var meetingModel: [MeetingModel] = [] {
    didSet {
      configureDataSource(meetingModel)
    }
  }
  private let isbn: Int
  private var pageNumber: Int = 1
  private let triggerMoreData = PublishSubject<Int>()

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

  init(isbn: Int) {
    self.isbn = isbn
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func bind() {
    let viewAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_: )))
      .map { [weak self ] _ in
        self?.pageNumber ?? 1
      }
    Observable.merge(viewAppear, triggerMoreData)
      .flatMap { NetworkService.shared.search.meetingSearchByISBN(isbn: self.isbn, page: $0) }
      .map { response -> BaseResponseType<Groups> in
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
      .drive { [weak self] meetingModel in
        guard let self = self else { return }
        if !meetingModel.isEmpty {
          self.pageNumber += 1
          self.meetingModel.append(contentsOf: meetingModel)
        }
      }
      .disposed(by: disposeBag)
  }
}

extension MorePopularViewController {
  /// - TAG: Layout
  private func configureHierarchy() {
    collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: MaruListCollectionViewLayout.createLayout()
    )
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
      .CellRegistration<MeetingListCell, MeetingModel> { cell, _, meetingModel in
        cell.bind(meetingModel)
      }

    dataSource = UICollectionViewDiffableDataSource<Section, MeetingModel>(
      collectionView: collectionView,
      cellProvider: { collectionView, indexPath, identifier in
        return collectionView.dequeueConfiguredReusableCell(
          using: cellRegistration,
          for: indexPath,
          item: identifier
        )
      }
    )

    var snapshot = NSDiffableDataSourceSnapshot<Section, MeetingModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
extension MorePopularViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let meetingModel = dataSource.itemIdentifier(for: indexPath) else { return }
    let targetViewController = JoinViewController(groupID: meetingModel.discussionGroupID)
    navigationController?.pushViewController(targetViewController, animated: true)
  }
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    if indexPath.item == meetingModel.endIndex - 1 {
      triggerMoreData.onNext(pageNumber)
    }
  }
}

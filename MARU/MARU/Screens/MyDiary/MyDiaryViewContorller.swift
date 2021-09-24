//
//  MyDiaryViewContorller.swift
//  MARU
//
//  Created by 오준현 on 2021/09/19.
//

import UIKit

import RxCocoa
import RxSwift

final class MyDiaryViewController: BaseViewController {

  override var hidesBottomBarWhenPushed: Bool {
    get { navigationController?.topViewController == self }
    set { super.hidesBottomBarWhenPushed = newValue }
  }

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 16
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.contentInset.top = 10
    collectionView.alwaysBounceVertical = true
    collectionView.register(cell: MyDiaryCell.self)
    return collectionView
  }()

  private let viewModel = MyDiaryViewModel()
  private var diaryList: [Group] = [] {
    didSet {
      collectionView.reloadData()
    }
  }

  override init() {
    super.init()
    setupCollectionView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    bind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setNavigationBar(isHidden: false)
    setupNavigation()
  }

  private func setupCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }

  private func render() {
    view.add(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }

  private func bind() {
    let viewDidLoadPublisher = PublishSubject<Void>()
    let input = MyDiaryViewModel.Input(viewDidLoad: viewDidLoadPublisher)
    let output = viewModel.transform(input: input)

    output.groupList
      .drive(onNext: { [weak self] list in
        guard let self = self,
              !list.isEmpty
        else { return }
        self.diaryList = list
      })
      .disposed(by: disposeBag)

    viewDidLoadPublisher.onNext(())
  }

  private func setupNavigation() {
    title = "내 일기장"
    navigationController?.navigationBar.isHidden = false
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    guard let navigationBar = navigationController?.navigationBar else { return }
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
  }
}

extension MyDiaryViewController: UIGestureRecognizerDelegate { }

extension MyDiaryViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: view.frame.width - 40, height: 142)
  }
}

extension MyDiaryViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: MyDiaryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.rx.dataBinder.onNext(diaryList[indexPath.item])
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return diaryList.count
  }
}

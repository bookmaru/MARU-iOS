//
//  MorePopularViewController.swift
//  MARU
//
//  Created by psychehose on 2021/05/29.
//

import UIKit

import RxCocoa
import RxSwift

final class MoreNewViewController: BaseViewController {

  private let buttonScrollView: UIScrollView = UIScrollView()
  fileprivate let allButton: UIButton = UIButton()
  fileprivate let artButton: UIButton = UIButton()
  fileprivate let literalButton: UIButton = UIButton()
  fileprivate let languageButton: UIButton = UIButton()
  fileprivate let philosophyButton: UIButton = UIButton()
  fileprivate let socialScienceButton: UIButton = UIButton()
  fileprivate let pureScienceButton: UIButton = UIButton()
  fileprivate let technicalScienceButton: UIButton = UIButton()
  fileprivate let historyButton: UIButton = UIButton()
  fileprivate let religionButton: UIButton = UIButton()
  fileprivate let etcButton: UIButton = UIButton()
  private let activatorView: UIActivityIndicatorView = UIActivityIndicatorView()
  private var collectionView: UICollectionView! = nil
  private let screenSize = UIScreen.main.bounds.size
  private var showFooter: Bool = false
  private let didScrollBottom = PublishSubject<(Bool, Int?)>()
  private var currentGroupCount: Int?
  private var meetingList: [MeetingModel] = []
  private let viewModel = MoreNewViewModel()
  private lazy var allButtons: [UIButton] = [
    allButton,
    artButton,
    literalButton,
    languageButton,
    philosophyButton,
    socialScienceButton,
    pureScienceButton,
    technicalScienceButton,
    historyButton,
    religionButton,
    etcButton
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    setupIndicatorView()
    setupButton()
    configureHierarchy()
    bind()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: false)
    navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    navigationController?.navigationBar.isTranslucent = false
    tabBarController?.tabBar.isHidden = true
  }

  private func bind() {
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_: )))
      .map { _ in () }

    let input = MoreNewViewModel.Input(
      viewTrigger: viewWillAppear,
      tapCategoryButton: rx.didTapButton,
      didScrollBottom: didScrollBottom.asObservable()
    )

    let output = viewModel.transform(input: input)

    output.load
      .drive { [weak self] in
        guard let self = self else { return }
        self.meetingList = $0
        self.currentGroupCount = $0.count
        self.collectionView.reloadData()
        self.activatorView.stopAnimating()
        self.collectionView.isHidden = false
      }
      .disposed(by: disposeBag)

    output.tapCategoryButton
      .drive(onNext: { [weak self]  in
        guard let self = self else { return }
        self.meetingList = $0
        self.currentGroupCount = $0.count
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
      })
      .disposed(by: disposeBag)

    output.fetchMore
      .drive(onNext: { [weak self] in
        guard let self = self else { return }
        self.showFooter = true
        self.stopUserInteraction()
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.scrollToSupplementaryView(
          ofKind: UICollectionView.elementKindSectionFooter,
          at: IndexPath(item: 0, section: 0),
          at: .bottom,
          animated: true
        )
        self.meetingList.append(contentsOf: $0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          self.showFooter = false
          self.currentGroupCount = self.meetingList.count
          self.collectionView.isUserInteractionEnabled = true
          self.collectionView.reloadData()
          self.startUserInteraction()
        }
      })
      .disposed(by: disposeBag)

    output.errorMessage
      .subscribe {
        debugPrint("error: \($0)")
      }
      .disposed(by: disposeBag)
  }
}

// MARK: - Method Helper
extension MoreNewViewController {
  private func stopUserInteraction() {
    collectionView.isUserInteractionEnabled = false
    allButtons.forEach { $0.isUserInteractionEnabled = false }
  }
  private func startUserInteraction() {
    collectionView.isUserInteractionEnabled = true
    allButtons.forEach { $0.isUserInteractionEnabled = true }
  }
  @objc private func didTapButton(_ sender: UIButton) {
    allButtons
      .forEach {
        $0.isSelected = $0 == sender
      }
  }
  private func setupIndicatorView() {
    activatorView.startAnimating()
    activatorView.hidesWhenStopped = true
  }

  private func setupButton() {
    let titles: [String] = [
      "전체",
      "예술",
      "문학",
      "어학",
      "철학/심리",
      "사회과학",
      "순수과학",
      "기술과학",
      "역사/지질",
      "종교",
      "기타"
    ]
    allButtons
      .enumerated().forEach { index, button in
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.veryLightPinkFour.cgColor
        button.layer.cornerRadius = 14
        button.sizeToFit()
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.brownGreyThree, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.setBackgroundColor(color: .clear, forState: .normal)
        button.setBackgroundColor(color: .mainBlue, forState: .selected)
        button.titleLabel?.textAlignment = .center
        button.setTitle(titles[index], for: .normal)
        button.tag = index
        button.addTarget(self, action: #selector(didTapButton(_ :)), for: .touchUpInside)
      }
    allButton.isSelected = true
  }
}
  // MARK: - Scroll Delegate (about FetchMore)
extension MoreNewViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let scrollView = collectionView else { return }
    let contentOffsetY = scrollView.contentOffset.y
    let collectionContentHeight = scrollView.contentSize.height
    let collectionFramHeight = scrollView.frame.height
    guard contentOffsetY > collectionContentHeight - collectionFramHeight + 100,
          let currentGroupCount = currentGroupCount
    else { return }
    didScrollBottom.onNext((true, currentGroupCount))
  }
}
extension MoreNewViewController {
  /// - Tag: create CollectionView Layout
  /// - Tag: Set CollectionView Properties
  /// - Tag: View Layout
  private func configureHierarchy() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical

    collectionView = UICollectionView(frame: .zero,
                                      collectionViewLayout: layout)
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = .white
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(cell: MeetingListCell.self)
    collectionView.register(
      IndicatorFooter.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: IndicatorFooter.reuseIdentifier
    )
    collectionView.isHidden = true

    buttonScrollView.contentSize = CGSize(width: 2 * screenSize.width, height: 30)
    buttonScrollView.showsHorizontalScrollIndicator = false

    activatorView.isHidden = false

    view.adds([
      activatorView,
      buttonScrollView,
      collectionView
    ])

    buttonScrollView.adds([
      allButton,
      artButton,
      literalButton,
      languageButton,
      philosophyButton,
      socialScienceButton,
      pureScienceButton,
      technicalScienceButton,
      historyButton,
      religionButton,
      etcButton
    ])

    activatorView.snp.makeConstraints { make in
      make.center.equalTo(view.safeAreaLayoutGuide.snp.center).inset(40)
    }
    buttonScrollView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(50)
    }
    allButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(20)
    }
    artButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalTo(allButton.snp.trailing).inset(-5)
    }
    literalButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalTo(artButton.snp.trailing).inset(-5)
    }
    languageButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalTo(literalButton.snp.trailing).inset(-5)
    }
    philosophyButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalTo(languageButton.snp.trailing).inset(-5)
    }
    socialScienceButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalTo(philosophyButton.snp.trailing).inset(-5)
    }
    pureScienceButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalTo(socialScienceButton.snp.trailing).inset(-5)
    }
    technicalScienceButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalTo(pureScienceButton.snp.trailing).inset(-5)
    }
    historyButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalTo(technicalScienceButton.snp.trailing).inset(-5)
    }
    religionButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalTo(historyButton.snp.trailing).inset(-5)
    }
    etcButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalTo(religionButton.snp.trailing).inset(-5)
    }
    collectionView.snp.makeConstraints { (make) in
      make.top.equalTo(buttonScrollView.snp.bottom).inset(-1)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }
}

extension MoreNewViewController: UICollectionViewDataSource {

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return meetingList.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MeetingListCell.reuseIdentifier,
            for: indexPath
    ) as? MeetingListCell else { return UICollectionViewCell() }

    cell.bind(meetingList[indexPath.item])
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: IndicatorFooter.reuseIdentifier,
            for: indexPath
    ) as? IndicatorFooter else {
      return UICollectionReusableView()
    }

    footer.indicatorView.startAnimating()
    return footer
  }
}
extension MoreNewViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    guard showFooter else { return .zero }
    return CGSize(width: collectionView.frame.width, height: 100)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: screenSize.width * 0.895, height: 142)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 15
  }

}

extension MoreNewViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? MeetingListCell,
          let groupID = Int(cell.getDiscussionGroupID()) else { return }
    let targetViewController = JoinViewController(groupID: groupID)
    navigationController?.pushViewController(targetViewController, animated: true)
  }
}
extension Reactive where Base: MoreNewViewController {

  var didTapButton: Observable<String> {
    return Observable.merge(
      base.allButton.rx.tap.map { Category.all },
      base.artButton.rx.tap.map { Category.art },
      base.literalButton.rx.tap.map { Category.literal },
      base.languageButton.rx.tap.map { Category.language },
      base.philosophyButton.rx.tap.map { Category.philosophy },
      base.socialScienceButton.rx.tap.map { Category.socialScience },
      base.pureScienceButton.rx.tap.map { Category.pureScience },
      base.technicalScienceButton.rx.tap.map { Category.technicalScience },
      base.historyButton.rx.tap.map { Category.history },
      base.religionButton.rx.tap.map { Category.religion },
      base.etcButton.rx.tap.map { Category.etc }
    )

    .flatMapLatest({ action -> Observable<String> in
      return Observable.just(action.simpleDescription())
    })
  }
}

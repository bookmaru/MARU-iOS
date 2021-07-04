//
//  RecentSearchViewController.swift
//  MARU
//
//  Created by psychehose on 2021/06/26.
//

import UIKit

final class RecentSearchViewController: BaseViewController {
  enum Section {
    case main
  }

  private let searchBar: UISearchBar = UISearchBar()

  private lazy var searchButton = UIBarButtonItem(title: "취소",
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(didTapCancleButton))

  private let recentSearchLabel = UILabel().then {
    $0.sizeToFit()
    $0.adjustsFontSizeToFitWidth = true
    $0.text = "최근 검색어"
    $0.textColor = .mainBlue
    $0.font = .systemFont(ofSize: 13, weight: .bold)
  }

  private let deleteLabel = UILabel().then {
    $0.sizeToFit()
    $0.adjustsFontSizeToFitWidth = true
    $0.text = "전체 삭제"
    $0.textColor = .black
    $0.alpha = 0.29
    $0.font = .systemFont(ofSize: 12, weight: .bold)
  }
  private let emptyView = EmptytMeetingView()
  private let screenSize = UIScreen.main.bounds.size
  private var searchListCollectionView: UICollectionView! = nil
  private var resultCollectionView: UICollectionView! = nil
  private var recentDataSource: UICollectionViewDiffableDataSource<Section, String>!
  private var resultDataSource: UICollectionViewDiffableDataSource<Section, MainModel>!

  private var initData = MainModel.initMainData

  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBar(isHidden: false)
    configureLayout()
    configureDataSource()
    configureResultDataSource()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    self.navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    self.navigationController?.navigationBar.isTranslucent = false
    configureSearchBar()
  }

  @objc
  private func didTapCancleButton() {
    self.navigationController?.popViewController(animated: true)
  }
}

extension RecentSearchViewController {
  func configureSearchBar() {
    searchBar.delegate = self
    self.navigationItem.leftBarButtonItem = nil
    self.navigationItem.hidesBackButton = true
    self.navigationItem.titleView = searchBar
    searchButton.tintColor = .black
    self.navigationItem.rightBarButtonItem = searchButton
    searchBar.placeholder = "검색을 해주세요"
  }
}
extension RecentSearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    print("Okay let's search")
  }
}

extension RecentSearchViewController {

  /// - TAG: collectionView Layout

  private func createListLayout() -> UICollectionViewLayout {
    var config = UICollectionLayoutListConfiguration(appearance: .plain)
    config.showsSeparators = false
    return UICollectionViewCompositionalLayout.list(using: config)
  }

  private func configureLayout() {
    searchListCollectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: createListLayout())
    searchListCollectionView.delegate = self
    resultCollectionView = UICollectionView(frame: .zero,
                                            collectionViewLayout: MaruListCollectionViewLayout.createLayout())
    searchListCollectionView.contentInsetAdjustmentBehavior = .never
    resultCollectionView.contentInsetAdjustmentBehavior = .never
    resultCollectionView.delegate = self
    searchListCollectionView.backgroundColor = .white
    resultCollectionView.backgroundColor = .white
    resultCollectionView.isHidden = true
    searchListCollectionView.isHidden = true

    view.add(recentSearchLabel) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(17)
        make.leading.equalToSuperview().inset(20)
      }
    }
    view.add(deleteLabel) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(22)
        make.trailing.equalToSuperview().inset(20)
      }
    }
    view.add(searchListCollectionView) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(49)
        make.leading.equalToSuperview().inset(27)
        make.trailing.equalToSuperview().inset(27)
        make.bottom.equalToSuperview()
      }
    }
    view.add(resultCollectionView) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        make.leading.equalToSuperview()
        make.trailing.equalToSuperview()
        make.bottom.equalToSuperview()
      }
    }
    view.add(emptyView) {
      $0.snp.makeConstraints { make in
        make.leading.equalToSuperview()
        make.trailing.equalToSuperview()
        make.height.equalTo(self.screenSize.height * 0.108)
        make.centerY.equalTo(self.view.safeAreaLayoutGuide)
      }
    }
  }

  private func remakeLayout() {
    searchListCollectionView.isHidden = true
    deleteLabel.isHidden = true
    recentSearchLabel.isHidden = true
    resultCollectionView.isHidden = false
  }

  private func backLayout() {
    recentSearchLabel.isHidden = false
    deleteLabel.isHidden = false
    searchListCollectionView.isHidden = false
    resultCollectionView.isHidden = true
  }
}

extension RecentSearchViewController {
  /// - TAG: DataSource
  private func configureDataSource() {
    let cellRegistration = UICollectionView
      .CellRegistration<UICollectionViewListCell, String> { (cell, _, item) in
        var content = cell.defaultContentConfiguration()
        content.text = item
        cell.contentConfiguration = content
      }
    recentDataSource =
      UICollectionViewDiffableDataSource<Section, String>(
        collectionView: searchListCollectionView,
        cellProvider: {(collectionView, indexPath, string) -> UICollectionViewCell in
          return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: string)})

    var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    snapshot.appendSections([.main])
    snapshot.appendItems(["살려줘", "노르웨이의 숲", "물리의 정석", "라라룰"])
    recentDataSource.apply(snapshot, animatingDifferences: false)
  }

  private func configureResultDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<MeetingListCell, MainModel> { (_, _, _) in
      // Populate the cell with our item description.
    }
    resultDataSource
      = UICollectionViewDiffableDataSource<Section, MainModel>(
        collectionView: resultCollectionView
      ) { (collectionView, indexPath, identifier ) -> UICollectionViewCell? in
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                            for: indexPath,
                                                            item: identifier)
      }

    var snapshot = NSDiffableDataSourceSnapshot<Section, MainModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(initData)
    resultDataSource.apply(snapshot, animatingDifferences: false)
  }
}
extension RecentSearchViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
}

extension RecentSearchViewController: SearchTextFieldDelegate, UITextFieldDelegate {
  func tapTextField() {
    backLayout()
  }
}

final class EmptytMeetingView: UIView {
  private let emptyLabel: UILabel = {
    let label = UILabel()
    label.text =
    """
    이 책은 지금 개설된 모임이 없어요.
    방장이 되어 직접 모임을 만들어보세요!
    """
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 13, weight: .medium)
    label.textColor = .black
    label.alpha = 0.22
    label.numberOfLines = 2
    return label
  }()

  private let openMeetingButton: UIButton = {
    let button = UIButton()
    button.contentEdgeInsets = UIEdgeInsets(top: 5,
                                            left: 10,
                                            bottom: 5,
                                            right: 10)
    let text = " 모임 열기"
    let imageAttachment = NSTextAttachment()
    imageAttachment.image = UIImage(systemName: "plus")?
      .withTintColor(.mainBlue)
      .withRenderingMode(.alwaysOriginal)

    let multipleAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 13, weight: .bold),
      .foregroundColor: UIColor.mainBlue
    ]

    let attributeString =  NSMutableAttributedString(attachment: imageAttachment)
    attributeString.append(NSAttributedString(string: text,
                                              attributes: multipleAttributes))
    button.setAttributedTitle(attributeString, for: .normal)

    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.mainBlue.cgColor
    button.layer.cornerRadius = 13

    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func configureLayout() {
    add(emptyLabel) {
      $0.snp.makeConstraints { make in
        make.top.equalToSuperview()
        make.centerX.equalToSuperview()
      }
    }
    add(openMeetingButton) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.emptyLabel.snp.bottom).inset(-13)
        make.centerX.equalToSuperview()
      }
    }
  }
}

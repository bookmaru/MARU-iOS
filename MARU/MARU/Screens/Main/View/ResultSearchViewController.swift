//
//  ResultSearchViewController.swift
//  MARU
//
//  Created by psychehose on 2021/07/28.
//

import UIKit

class ResultSearchViewController: BaseViewController, UISearchBarDelegate {
  enum Section {
    case main
  }

  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "검색을 해주세요"
    return searchBar
  }()

  lazy var canclehButton: UIBarButtonItem = {
//    let canclehButton = UIBarButtonItem()
    let cancleButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(testCancle))
    cancleButton.tintColor = .black
//    canclehButton.title = "취소"
    return cancleButton
  }()
  private let activatorView: UIActivityIndicatorView = {
    let activatorView = UIActivityIndicatorView()
    activatorView.startAnimating()
//    activatorView.hidesWhenStopped = true
    return activatorView
  }()

  private var initData = BookModel.initMainData
  private let emptyView = EmptytMeetingView()
  private let screenSize = UIScreen.main.bounds.size
  private var resultCollectionView: UICollectionView! = nil
  private var resultDataSource: UICollectionViewDiffableDataSource<Section, BookModel>!

  override func viewDidLoad() {
    super.viewDidLoad()
    configureLayout()
    configureResultDataSource()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    self.navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    self.navigationController?.navigationBar.isTranslucent = false
    configureSearchBar()
  }
  @objc func testCancle() {
    navigationController?.popToRootViewController(animated: true)
  }
}
extension ResultSearchViewController {
  private func configureSearchBar() {
    navigationItem.leftBarButtonItem = nil
    navigationItem.hidesBackButton = true
    navigationItem.titleView = searchBar
    searchBar.showsCancelButton = false
    navigationItem.rightBarButtonItem = canclehButton
  }
}
extension ResultSearchViewController {
  private func configureLayout() {
    resultCollectionView = UICollectionView(frame: .zero,
                                            collectionViewLayout: MaruListCollectionViewLayout.createLayout())
    resultCollectionView.contentInsetAdjustmentBehavior = .never
    resultCollectionView.delegate = self
    resultCollectionView.backgroundColor = .white

    resultCollectionView.isHidden = true
    emptyView.isHidden = true

    view.add(activatorView) {
      $0.snp.makeConstraints { make in
        make.center.equalTo(self.view.snp.center)
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
}

extension ResultSearchViewController {
  /// - TAG: DataSource
  private func configureResultDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<MeetingListCell, BookModel> { (_, _, _) in
      // Populate the cell with our item description.
    }
    resultDataSource
      = UICollectionViewDiffableDataSource<Section, BookModel>(
        collectionView: resultCollectionView
      ) { (collectionView, indexPath, identifier ) -> UICollectionViewCell? in
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                            for: indexPath,
                                                            item: identifier)
      }

    var snapshot = NSDiffableDataSourceSnapshot<Section, BookModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(initData)
    resultDataSource.apply(snapshot, animatingDifferences: false)
  }

}
extension ResultSearchViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
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

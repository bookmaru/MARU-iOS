//
//  ResultSearchViewController.swift
//  MARU
//
//  Created by psychehose on 2021/07/28.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

protocol OpenButtonDelegate: AnyObject {
  func didTapOpenButton()
}

final class ResultSearchViewController: BaseViewController, UISearchBarDelegate {

  enum Section {
    case main
  }

  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "검색을 해주세요"
    return searchBar
  }()

  private let cancelButton: UIBarButtonItem = {
    let cancelButton = UIBarButtonItem()
    cancelButton.tintColor = .black
    cancelButton.title = "취소"
    return cancelButton
  }()

  private let activatorView: UIActivityIndicatorView = {
    let activatorView = UIActivityIndicatorView()
    activatorView.startAnimating()
    activatorView.hidesWhenStopped = true
    return activatorView
  }()

  private let emptyView = EmptytMeetingView()
  private let screenSize = UIScreen.main.bounds.size
  private var resultCollectionView: UICollectionView! = nil
  private var resultDataSource: UICollectionViewDiffableDataSource<Section, MeetingModel>!
  private var searchedKeyword: String! = nil
  private var viewModel =  ResultSearchViewModel()
  private var keyword: String! = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    emptyView.delegate = self
    configureLayout()
    bind()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    navigationController?.navigationBar.isTranslucent = false
    configureSearchBar()
  }
  @objc func testCancel() {
    navigationController?.popToRootViewController(animated: true)
  }
  func transferKeyword(keyword: String) {
    searchedKeyword = keyword
    searchBar.searchTextField.text = keyword
    self.keyword = keyword
  }
}
extension ResultSearchViewController {
  private func bind() {
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_: )))
      .map { _ in () }

    let input = ResultSearchViewModel.Input(
      viewTrigger: viewWillAppear,
      keyword: keyword,
      tapCancelButton: cancelButton.rx.tap.asDriver(),
      tapTextField: Driver.merge(
        searchBar.searchTextField.rx.controlEvent(.touchDown).asDriver(),
        searchBar.rx.textDidBeginEditing.asDriver())
    )
    let output = viewModel.transform(input: input)

    output.result
      .drive { [weak self] meetingModels in
        guard let self = self else { return }
        self.resultCollectionView.isHidden = meetingModels.isEmpty
        self.emptyView.isHidden = !meetingModels.isEmpty
        if !meetingModels.isEmpty {
          self.configureResultDataSource(meetingModels)
        }
        self.activatorView.stopAnimating()
      }
      .disposed(by: disposeBag)

    output.cancel
      .drive(onNext: { [weak self] _ in
        self?.navigationController?.popToRootViewController(animated: true)
      })
      .disposed(by: disposeBag)

    output.reSearch
      .drive(onNext: { [weak self] _ in
        self?.navigationController?.popViewController(animated: false)
      })
      .disposed(by: disposeBag)

    output.canMakeGroup
      .drive(onNext: { [weak self] in
        guard let self = self else { return }
        self.emptyView.openMeetingButton.isEnabled = $0
        if !$0 {
          self.showToast("이미 방을 2개 만들었습니다.")
        }
      })
      .disposed(by: disposeBag)
  }
}
extension ResultSearchViewController {
  private func configureSearchBar() {
    navigationItem.leftBarButtonItem = nil
    navigationItem.hidesBackButton = true
    navigationItem.titleView = searchBar
    searchBar.showsCancelButton = false
    navigationItem.rightBarButtonItem = cancelButton
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
    activatorView.isHidden = false

    view.add(activatorView) {
      $0.snp.makeConstraints { make in
        make.center.equalTo(self.view.snp.center)
      }
    }

    view.add(resultCollectionView) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(1)
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
  private func configureResultDataSource(_ items: [MeetingModel]) {
    let cellRegistration = UICollectionView
      .CellRegistration<MeetingListCell, MeetingModel> { cell, _, meetingModel in
        cell.bind(meetingModel)
      }
    resultDataSource = UICollectionViewDiffableDataSource<Section, MeetingModel>(
      collectionView: resultCollectionView
    ) { collectionView, indexPath, identifier -> UICollectionViewCell? in
      return collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: identifier
      )
    }

    var snapshot = NSDiffableDataSourceSnapshot<Section, MeetingModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    resultDataSource.apply(snapshot, animatingDifferences: false)
  }
}
extension ResultSearchViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let meetingModel = resultDataSource.itemIdentifier(for: indexPath) else { return }
    let targetVC = JoinViewController(groupID: meetingModel.discussionGroupID)
    navigationController?.pushViewController(targetVC, animated: true)
  }
}

extension ResultSearchViewController: OpenButtonDelegate {
  func didTapOpenButton() {
    /// - TAG: 모임열기 버튼 클릭
    let targetVC = BookSearchViewController(keyword: keyword)
    navigationController?.pushViewController(targetVC, animated: true)
  }
}

// MARK: - Empty View
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

  lazy var openMeetingButton: DefalutButton = {
    let button = DefalutButton()
    button.contentEdgeInsets = UIEdgeInsets(top: 5,
                                            left: 10,
                                            bottom: 5,
                                            right: 10)
    let text = " 모임 열기"

    let normalImageAttachment = NSTextAttachment()
    normalImageAttachment.image = UIImage(systemName: "plus")?
      .withTintColor(.mainBlue)
      .withRenderingMode(.alwaysOriginal)

    let normalAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 13, weight: .bold),
      .foregroundColor: UIColor.mainBlue
    ]

    let disabledImageAttachment = NSTextAttachment()
    disabledImageAttachment.image = UIImage(systemName: "plus")?
      .withTintColor(.veryLightGray)
      .withRenderingMode(.alwaysOriginal)

    let disabledAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 13, weight: .bold),
      .foregroundColor: UIColor.veryLightGray
    ]

    let normalAttributeString =  NSMutableAttributedString(attachment: normalImageAttachment)
    normalAttributeString.append(NSAttributedString(
      string: text,
      attributes: normalAttributes
    ))

    let disabledAttributeString =  NSMutableAttributedString(attachment: disabledImageAttachment)
    disabledAttributeString.append(NSAttributedString(
      string: text,
      attributes: disabledAttributes
    ))

    button.setAttributedTitle(normalAttributeString, for: .normal)
    button.setAttributedTitle(disabledAttributeString, for: .disabled)

    button.addTarget(self, action: #selector(didTapOpenButton), for: .touchUpInside)
    return button
  }()

  weak var delegate: OpenButtonDelegate?
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  @objc func didTapOpenButton() {
    delegate?.didTapOpenButton()
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

//
//  ResultSearchViewController.swift
//  MARU
//
//  Created by psychehose on 2021/07/28.
//

import UIKit

import RxSwift
import RxCocoa

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
      .drive { [self = self] in
        if $0.isEmpty == true {
          resultCollectionView.isHidden = true
          emptyView.isHidden = false
        }

        if $0.isEmpty == false {
          resultCollectionView.isHidden = false
          configureResultDataSource($0)
        }
        activatorView.stopAnimating()
      }
      .disposed(by: disposeBag)

    output.cancel
      .drive(onNext: { [self] _ in
        navigationController?.popToRootViewController(animated: true)
      })
      .disposed(by: disposeBag)

    output.reSearch
      .drive(onNext: { [self] _ in
        navigationController?.popViewController(animated: false)
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
    // TODO: 여기에 화면전환
  }
}

extension ResultSearchViewController: OpenButtonDelegate {
  func didTapOpenButton() {
    print("tapped Open Button")
    // 여기에 화면 전환
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

  let openMeetingButton: UIButton = {
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

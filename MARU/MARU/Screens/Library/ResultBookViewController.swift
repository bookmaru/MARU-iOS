//
//  ResultBookViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/20.
//

import UIKit

class ResultBookViewController: BaseViewController, UISearchBarDelegate {

  enum Section {
    case main
  }

  private let searchBar = UISearchBar().then {
    $0.placeholder = "책 제목"
  }

  private let cancelButton = UIBarButtonItem().then {
    $0.tintColor = .black
    $0.title = "취소"
  }

  private let activatorView = UIActivityIndicatorView().then {
    $0.startAnimating()
    $0.hidesWhenStopped = true
  }

  private var resultCollectionView: UICollectionView! = nil
  private var resultDataSource: UICollectionViewDiffableDataSource<Section, MeetingModel>!
  private var searchedKeyword: String! = nil
  // TODO: - 책 검색하는 서버 연결
  private var viewModel =  ResultSearchViewModel()
  private var keyword: String! = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setSearchBar()
  }
}

extension ResultBookViewController {
  func render() {
  }
  func setSearchBar() {
    navigationItem.leftBarButtonItem = nil
    navigationItem.hidesBackButton = true
    navigationItem.titleView = searchBar
    navigationItem.rightBarButtonItem = cancelButton
    navigationItem.rightBarButtonItem?.tintColor = .black
  }

  @objc func didTapCancelButton() {
    self.navigationController?.popViewController(animated: false)
  }
}

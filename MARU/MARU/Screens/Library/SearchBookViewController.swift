//
//  SearchBookViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/14.
//

import UIKit

class SearchBookViewController: BaseViewController {
  let searchBar = UISearchBar().then {
    $0.placeholder = "책 제목"
  }
  let recentSearchLabel = UILabel().then {
    $0.text = "최근 검색어"
    $0.textColor = .mainBlue
    $0.font = .systemFont(ofSize: 13, weight: .bold)
  }
  let deleteButton = UIButton().then {
    $0.setTitle("전체 삭제", for: .normal)
    $0.setTitleColor(.lightGray, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    setLayout()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setSearchBar()
    // setNavigationBar(isHidden: true)
  }
}

extension SearchBookViewController {
  func setLayout() {
    view.add(recentSearchLabel) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).offset(17)
        make.leading.equalToSuperview().offset(20)
      }
    }
    view.add(deleteButton) {
      $0.snp.makeConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide).offset(17)
        make.trailing.equalToSuperview().offset(-20)
      }
    }
  }
  func setSearchBar() {
    navigationItem.leftBarButtonItem = nil
    navigationItem.hidesBackButton = true
    navigationItem.titleView = searchBar
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(didTapCancelButton))
    navigationItem.rightBarButtonItem?.tintColor = .black
  }
  @objc func didTapCancelButton() {
    // self.navigationController?.popViewController(animated: false)
    // MARK: - 지금 임시로 화면 전환만 push로 걸어놓겠음
    let viewController = ResultBookViewController()
    self.navigationController?.pushViewController(viewController, animated: false)
  }
}

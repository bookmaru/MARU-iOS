//
//  ResultBookViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/20.
//

import UIKit

class ResultBookViewController: BaseViewController {

  private let searchBar = UISearchBar().then {
    $0.placeholder = "책 제목"
  }
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
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "취소",
      style: .plain,
      target: self,
      action: #selector(didTapCancelButton)
    )
    navigationItem.rightBarButtonItem?.tintColor = .black
  }

  @objc func didTapCancelButton() {
    self.navigationController?.popViewController(animated: false)
  }
}

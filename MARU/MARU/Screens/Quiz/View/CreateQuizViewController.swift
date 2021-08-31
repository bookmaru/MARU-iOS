//
//  CreateQuizViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/09.
//

import UIKit

class CreateQuizViewController: BaseViewController {

  private var tableView: UITableView! = nil
  private let headerView: UIView = {
    let view = UIView()
    let label = UILabel()
    label.text = "퀴즈 작성"
    label.font = .systemFont(ofSize: 13, weight: .bold)
    view.add(label) {
      $0.snp.makeConstraints { make in
        make.bottom.equalToSuperview().inset(8)
        make.leading.equalToSuperview().inset(16)
      }
    }
    return view
  }()
  private let oneLinePlaceholder = "토론에 대한 소개를 70자 이내로 입력해주세요."
  override func viewDidLoad() {
    super.viewDidLoad()
    configureComponent()
    configureLayout()
  }
}
extension CreateQuizViewController {
  private func configureComponent() {
    tableView = UITableView(frame: .zero, style: .grouped)
    tableView.backgroundColor = .white
    tableView.register(
      CreateQuizCell.self,
      forCellReuseIdentifier: CreateQuizCell.reuseIdentifier
    )
    tableView.register(
      BookContentCell.self,
      forCellReuseIdentifier: BookContentCell.reuseIdentifier
    )
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelection = false
  }
  private func configureLayout() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(68.calculatedHeight)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaInsets.bottom).inset(5)
    }
  }
}

extension CreateQuizViewController: UITableViewDelegate { }
extension CreateQuizViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 5
    default:
      return 0
    }
  }
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(
              withIdentifier: BookContentCell.reuseIdentifier,
              for: indexPath) as? BookContentCell else { return UITableViewCell() }
      return cell

    case 1:
      guard let cell = tableView.dequeueReusableCell(
              withIdentifier: CreateQuizCell.reuseIdentifier,
              for: indexPath) as? CreateQuizCell else { return UITableViewCell() }
      return cell

    default:
      return UITableViewCell()
    }

  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 280.calculatedHeight
    case 1:
      return 170.calculatedHeight
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 0
    case 1:
      return 50.calculatedHeight
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 0
    case 1:
      return 10
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return headerView
  }
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    tableView.deselectRow(at: indexPath, animated: false)
    return nil
  }
}

extension CreateQuizViewController: UITextViewDelegate { }

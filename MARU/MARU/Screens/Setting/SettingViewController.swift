//
//  SettingViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/08/06.
//

import UIKit

final class SettingViewController: BaseViewController {

  override var hidesBottomBarWhenPushed: Bool {
    get { navigationController?.topViewController == self }
    set { super.hidesBottomBarWhenPushed = newValue }
  }

  enum Preference: String {
    case notice = "공지사항"
    case info = "서비스 이용약관"
    case opensource = "오픈소스 라이선스"
    case logout = "로그아웃"
    case resign = "탈퇴하기"
  }

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: ScreenSize.width, height: 49)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cell: SettingCollectionViewCell.self)
    collectionView.backgroundColor = .white
    return collectionView
  }()

  private let row: [Preference] = [
    .notice,
    .info,
    .opensource,
    .logout,
    .resign
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setNavigation()
  }

  private func render() {
    title = "환경설정"
    view.add(collectionView) { view in
      view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    collectionView.delegate = self
    collectionView.dataSource = self
  }

  private func setNavigation() {
    setNavigationBar(isHidden: false)
    guard let navigationBar = navigationController?.navigationBar else { return }
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
    navigationItem.title = "환경설정"
    navigationBar.titleTextAttributes = [
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)
    ]
    navigationController?.interactivePopGestureRecognizer?.delegate = self
  }

  private func logout() {
    KeychainHandler.shared.logout()
    let viewController = OnboardingViewController()
    viewController.modalPresentationStyle = .fullScreen
    if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
      delegate.window?.rootViewController = viewController
    }
    present(viewController, animated: false)
  }
}

extension SettingViewController: UIGestureRecognizerDelegate { }

extension SettingViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    switch row[indexPath.item] {
    case .logout:
      let alert = UIAlertController(title: "로그아웃을 하시겠나요...? 😥", message: "", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
        self.logout()
      })
      alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
      present(alert, animated: true) {
        let roomIDList = RealmService.shared.findRoomID()
        roomIDList.forEach {
          ChatService.shared.unsubscribeRoom(roomID: $0)
        }
      }
    default:
      break
    }
  }
}

extension SettingViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return row.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SettingCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.separatorViewRow(row: indexPath.item)
    cell.titleLabel(title: row[indexPath.item].rawValue)
    return cell
  }
}

//
//  ChatViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/04/20.
//

import UIKit

final class ChatViewController: BaseViewController {
  typealias ViewModel = ChatViewModel
  typealias MyChatCell = MyChatCollectionViewCell
  typealias OtherChatCell = OtherChatCollectionViewCell
  typealias OtherProfileChatCell = OtherProfileChatCollectionViewCell

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cell: MyChatCell.self)
    collectionView.register(cell: OtherChatCell.self)
    collectionView.register(cell: OtherProfileChatCell.self)
    collectionView.backgroundColor = .bgLightgray
    return collectionView
  }()

  private var data: [Chat] = [
    .message(data: .init(profileImage: nil, name: nil, message: "123456123152136546312654651너무 오래 갈때 여어어어어엉어어엉어어")),
    .otherProfile(data: .init(profileImage: nil, name: nil, message: "1231111321231543213215421")),
    .otherMessage(data: .init(
      profileImage: nil,
      name: nil,
      message: "123456123152136546312654651너무 오래 갈때 여어어어어엉어어엉어어"
    )),
    .message(data: .init(profileImage: nil, name: nil, message: "123")),
    .otherProfile(data: .init(profileImage: nil, name: nil, message: "1231111321231543213215421")),
    .otherMessage(data: .init(
      profileImage: nil,
      name: nil,
      message: "123456123152136546312654651너무 오래 갈때 여어어어어엉어어엉어어"
    )),
    .message(data: .init(profileImage: nil, name: nil, message: "123")),
    .otherProfile(data: .init(profileImage: nil, name: nil, message: "1231111321231543213215421")),
    .otherMessage(data: .init(
      profileImage: nil,
      name: nil,
      message: "344545너무 오래 갈때 56"
    )),
    .message(data: .init(profileImage: nil, name: nil, message: "123")),
    .otherProfile(data: .init(profileImage: nil, name: nil, message: "2234")),
    .otherMessage(data: .init(
      profileImage: nil,
      name: nil,
      message: "123456123152136546312654651너무 오래 갈때 여어어어어엉어어엉어어"
    )),
    .message(data: .init(profileImage: nil, name: nil, message: "123")),
    .otherProfile(data: .init(profileImage: nil, name: nil, message: "123123")),
    .otherMessage(data: .init(
      profileImage: nil,
      name: nil,
      message: "123456123152136546312654651너무 오래 갈때 여어어어어엉어어엉어어"
    )),
    .message(data: .init(profileImage: nil, name: nil, message: "123")),
    .otherProfile(data: .init(profileImage: nil, name: nil, message: "1231111321231543213215421")),
    .otherMessage(data: .init(
      profileImage: nil,
      name: nil,
      message: "123456123152136546312654651너무 오래 갈때 여어어어어엉어어엉어어"
    )),
    .message(data: .init(profileImage: nil, name: nil, message: "123")),
    .otherProfile(data: .init(profileImage: nil, name: nil, message: "1231111321231543213215421")),
    .otherMessage(data: .init(
      profileImage: nil,
      name: nil,
      message: "123456123152136546312654651너무 오래 갈때 여어어어어엉어어엉어어"
    ))
  ] {
    didSet { collectionView.reloadData() }
  }

  private let bottomView = InputView()

  private let viewModel = ChatViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
    bind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    tabBarController?.tabBar.isHidden = true
  }
}

extension ChatViewController {
  private func layout() {
    view.add(bottomView) {
      $0.snp.makeConstraints {
        $0.leading.bottom.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(50)
      }
    }
    view.add(collectionView) {
      $0.snp.makeConstraints {
        $0.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
        $0.bottom.equalTo(self.bottomView.snp.top)
      }
      $0.delegate = self
      $0.dataSource = self
    }
  }

  private func bind() {
    bindKeyboardNotification()
    bottomView.rx.didTapSendButton
      .subscribe(onNext: { text in
        print(text)
      })
      .disposed(by: disposeBag)
  }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: data[indexPath.item].cellHeight)
  }
}

extension ChatViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return data.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch data[indexPath.item] {
    case .message(let data):
      let cell: MyChatCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.rx.dataBinder.onNext(data)

      return cell

    case .otherMessage(let data):
      let cell: OtherChatCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.rx.dataBinder.onNext(data)

      return cell

    case .otherProfile(let data):
      let cell: OtherProfileChatCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.rx.dataBinder.onNext(data)

      return cell
    }
  }
}

// MARK: - Keyboard
extension ChatViewController {
  private func bindKeyboardNotification() {
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillShowNotification)
      .subscribe(onNext: { [weak self] notification in
        guard let self = self,
              let duration = self.keyboardDuration(notification: notification),
              let curve = self.keyboardCurve(notification: notification),
              let height = self.keyboradHeight(notification: notification),
              let bottomPadding = self.bottomPadding()
        else { return }
        self.bottomView.snp.updateConstraints {
          $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(height - bottomPadding)
        }
        self.collectionView.snp.updateConstraints {
          $0.bottom.equalTo(self.bottomView.snp.top)
        }
        self.view.setNeedsLayout()
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .init(rawValue: curve),
                       animations: {
                        self.view.layoutIfNeeded()
        })
      }).disposed(by: disposeBag)

    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillHideNotification)
      .subscribe(onNext: { [weak self] notification in
        guard let self = self,
              let duration = self.keyboardDuration(notification: notification),
              let curve = self.keyboardCurve(notification: notification)
        else { return }
        self.bottomView.snp.updateConstraints {
          $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        self.collectionView.snp.updateConstraints {
          $0.bottom.equalTo(self.bottomView.snp.top)
        }
        self.view.setNeedsLayout()
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .init(rawValue: curve),
                       animations: {
                        self.view.layoutIfNeeded()
        })
      }).disposed(by: disposeBag)
  }

  private func bottomPadding() -> CGFloat? {
    guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    else { return nil }
    return keyWindow.safeAreaInsets.bottom
  }

  private func keyboardDuration(notification: Notification) -> TimeInterval? {
    guard let info = notification.userInfo,
          let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
    else { return nil }
    return duration
  }

  private func keyboardCurve(notification: Notification) -> UInt? {
    guard let info = notification.userInfo,
          let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
    else { return nil }
    return curve
  }

  private func keyboradHeight(notification: Notification) -> CGFloat? {
    guard let info = notification.userInfo,
          let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    else { return nil }
    return keyboardFrame.height
  }
}

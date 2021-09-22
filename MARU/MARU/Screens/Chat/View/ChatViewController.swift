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

  override var hidesBottomBarWhenPushed: Bool {
    get { navigationController?.topViewController == self }
    set { super.hidesBottomBarWhenPushed = newValue }
  }

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cell: MyChatCell.self)
    collectionView.register(cell: OtherChatCell.self)
    collectionView.register(cell: OtherProfileChatCell.self)
    collectionView.backgroundColor = .bgLightgray
    collectionView.contentInset.top = 10
    collectionView.contentInset.bottom = 10
    return collectionView
  }()

  private var data: [Chat] = [] {
    didSet {
      collectionView.reloadData()
    }
  }

  private let bottomView = InputView()

  private let viewModel: ChatViewModel
  private let roomID: Int

  init(roomID: Int, title: String) {
    self.viewModel = ChatViewModel(
      roomID: roomID,
      sendPublisher: bottomView.rx.didTapSendButton
    )
    self.roomID = roomID
    super.init()
    self.title = title
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
    bind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    scrollToBottom()
    setNavigation()
  }

  private func scrollToBottom(_ animated: Bool = false) {
    DispatchQueue.main.async {
      let lastItem = self.data.count - 1
      let indexPath = IndexPath(row: 0, section: lastItem)
      self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }
  }

  private func setNavigation() {
    navigationController?.navigationBar.isHidden = false
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    guard let navigationBar = navigationController?.navigationBar else { return }
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
  }
}

extension ChatViewController: UIGestureRecognizerDelegate { }

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

    let input = ViewModel.Input()
    let ouput = viewModel.transform(input: input)

    ouput.chat
      .drive(onNext: { chat in
        self.data = chat
        let cov = self.collectionView
        let offset = cov.contentSize.height - (cov.contentOffset.y + cov.frame.height)
        if offset < 30 {
          self.scrollToBottom(true)
        }
      })
      .disposed(by: disposeBag)
  }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: data[indexPath.section].cellHeight)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    if section != 0 {
      let prevSection = data[section - 1]
      let currentSection = data[section]
      switch currentSection {
      case .message:
        return calculateMessage(prevMessage: prevSection)
      case .otherMessage:
        return calculateOtherMessage(prevMessage: prevSection)
      case .otherProfile:
        return calculateOtherProfile(prevMessage: prevSection)
      }
    }
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}

extension ChatViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return data.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 1
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch data[indexPath.section] {
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
      })
      .disposed(by: disposeBag)

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
      })
      .disposed(by: disposeBag)
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
// MARK: 채팅 레이아웃 셀 UIEdgeInset
extension ChatViewController {
  private func calculateMessage(prevMessage: Chat) -> UIEdgeInsets {
    switch prevMessage {
    case .message:
      return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    case .otherMessage:
      return UIEdgeInsets(top: 11, left: 0, bottom: 0, right: 0)
    case .otherProfile:
      return UIEdgeInsets(top: 11, left: 0, bottom: 0, right: 0)
    }
  }

  private func calculateOtherMessage(prevMessage: Chat) -> UIEdgeInsets {
    switch prevMessage {
    case .message:
      return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    case .otherMessage:
      return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    case .otherProfile:
      return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
  }

  private func calculateOtherProfile(prevMessage: Chat) -> UIEdgeInsets {
    switch prevMessage {
    case .message:
      return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    case .otherMessage:
      return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    case .otherProfile:
      return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
  }
}

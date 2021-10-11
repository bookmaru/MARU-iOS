//
//  ChatViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/04/20.
//

import UIKit

import RxCocoa
import RxSwift

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

  private let didLongTapBubblePublisher = PublishSubject<RealmChat>()
  private let didTapGroupButtonPublisher = PublishSubject<Void>()
  private let reportPublisher = PublishSubject<RealmChat>()
  private let bottomView = InputView()
  private let rightBarButton = UIBarButtonItem(
    image: Image.group841?.withRenderingMode(.alwaysTemplate),
    style: .plain,
    target: self,
    action: nil
  ).then {
    $0.tintColor = .mainBlue
  }

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
    touchEvent()
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
    guard !data.isEmpty else { return }
    DispatchQueue.main.async {
      let lastItem = self.data.count - 1
      let indexPath = IndexPath(row: 0, section: lastItem)
      self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }
  }

  private func setNavigation() {
    navigationItem.rightBarButtonItem = rightBarButton
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    guard let navigationBar = navigationController?.navigationBar else { return }
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
    navigationBar.tintColor = .black
  }

  private func touchEvent() {
    collectionView.rx
      .tapGesture { _, delegate in
        delegate.simultaneousRecognitionPolicy = .never
      }
      .subscribe(onNext: { [weak self] _ in
        self?.view.endEditing(true)
      })
      .disposed(by: disposeBag)
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

    didLongTapBubblePublisher
      .subscribe(onNext: { [weak self] chat in
        guard let self = self else { return }
        let title = "신고하기"
        let message = """
        부적적한 채팅인 경우 신고해주세요.
        관리자가 검토하고 조치합니다.
        """
        self.simpleAlertWithHandler(
          title: title,
          message: message,
          left: "아니요",
          right: "신고하기"
        ) { _ in
          self.reportPublisher.onNext(chat)
        }
      })
      .disposed(by: disposeBag)

    rightBarButton.rx.tap.map { _ in }
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        let optionMenu = UIAlertController(
          title: "토론방을 저장하여 내 서재에 담아두세요 !",
          message: "내가 참여했던 토론방을 확인할 수 있으며, 방장 평가를 통해 토론의 질을 높일 수 있습니다.",
          preferredStyle: .actionSheet
        )

        let saveAction = UIAlertAction(
          title: "저장",
          style: .default,
          handler: { _ -> Void in
            self.didTapGroupButtonPublisher.onNext(())
          })

        let cancelAction = UIAlertAction(
          title: "닫기",
          style: .cancel,
          handler: nil
        )
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)

        self.present(optionMenu, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)

    let viewWillAppear = rx.viewWillAppear

    let input = ViewModel.Input(
      viewWillAppear: viewWillAppear,
      didLongTap: reportPublisher,
      didTapGroupButton: didTapGroupButtonPublisher
    )

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

    ouput.isReportSuccess
      .drive(onNext: { [weak self] isSuccess in
        guard let self = self else { return }
        if isSuccess {
          self.showToast("신고가 완료되었습니다.")
          return
        }
        self.showToast("오류로 인해 신고하지 못했습니다.")
      })
      .disposed(by: disposeBag)

    ouput.isCheckNotice
      .filter { !$0 }
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.notice(roomID: self.roomID)
      })
      .disposed(by: disposeBag)
  }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: view.frame.width, height: data[indexPath.section].cellHeight)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    if section == 0 {
      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
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
}

extension ChatViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return data.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
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
      cell.rx.didLongTapBubble
        .map { data }
        .bind(to: didLongTapBubblePublisher)
        .disposed(by: cell.disposeBag)

      return cell

    case .otherProfile(let data):
      let cell: OtherProfileChatCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.rx.dataBinder.onNext(data)
      cell.rx.didLongTapBubble
        .map { data }
        .bind(to: didLongTapBubblePublisher)
        .disposed(by: cell.disposeBag)

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
        let cov = self.collectionView
        let offset = cov.contentSize.height - (cov.contentOffset.y + cov.frame.height)
        if offset < 30 {
          self.scrollToBottom(true)
        }
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

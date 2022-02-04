//
//  JoinViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/06/21.
//

import UIKit

import Then
import RxCocoa
import RxSwift

final class JoinViewController: BaseViewController {
  private let bookImageView = UIImageView().then {
    $0.image = Image.testImage
  }

  private let gradientImageView = UIImageView().then {
    $0.image = Image.gradientImage
  }

  private let bookTitleLabel = UILabel().then {
    $0.text = "책 제목 들어가는 곳"
    $0.numberOfLines = 2
    $0.font = .boldSystemFont(ofSize: 16)
    $0.textColor = .white
  }

  private let leftTimeLabel = UILabel().then {
    $0.textColor = .white
    let text = "토론이 1일 남았습니다."
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(
      .foregroundColor, value: UIColor.cornFlowerBlue, range: (text as NSString).range(of: "1")
    )
    $0.attributedText = attributedString
    $0.font = .boldSystemFont(ofSize: 15)
  }

  private let contentView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
    $0.applyShadow(color: .black, alpha: 0.16, shadowX: 0, shadowY: 0, blur: 10)
  }

  private let leadNameLabel = UILabel().then {
    $0.text = "방장 이름"
    $0.font = .systemFont(ofSize: 14, weight: .bold)
  }

  private let bookIconImageView = UIImageView().then {
    $0.image = Image.searchIcScore
  }

  private let partyImageView = UIImageView().then {
    $0.image = Image.searchIcMember
  }

  private let leadScoreLabel = UILabel().then {
    $0.text = "방장 평점"
    $0.font = .systemFont(ofSize: 10, weight: .medium)
    $0.textAlignment = .left
    $0.textColor = .mainBlue
  }

  private let scoreStateLabel = UILabel().then {
    $0.text = "5.0"
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.textAlignment = .left
    $0.textColor = .mainBlue
  }

  private let participantLabel = UILabel().then {
    $0.text = "현재 인원"
    $0.font = .systemFont(ofSize: 10, weight: .medium)
    $0.textAlignment = .left
    $0.textColor = .mainBlue
  }

  private let partyStateLabel = UILabel().then {
    $0.textColor = .mainBlue
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.textAlignment = .left
  }

  private let leftQuoteImageView = UIImageView().then {
    $0.image = Image.quotationMarkLeft
  }

  private let contentLabel = VerticalAlignLabel().then {
    $0.font = RIDIBatangFont.medium.of(size: 12)
    $0.textAlignment = .center
    $0.numberOfLines = 3
    $0.text = "식물책표지가되게예쁘네네네네네네무슨내용일까까까가가가가가가가가와랄랄라와랄랄라와랄랄라와랄라라"
  }

  private let rightQuoteImageView = UIImageView().then {
    $0.image = Image.quotationMarkRight
  }

  private let entryButton = UIButton().then {
    $0.backgroundColor = .mainBlue
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    $0.setTitle("참여하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
  }

  private let viewModel = JoinViewModel()
  fileprivate var data: GroupInformation? {
    didSet {
      guard let groups = data?.groups else { return }
      let imageURL = groups.image
      bookImageView.image(url: imageURL, defaultImage: Image.defalutImage ?? UIImage())
      bookTitleLabel.text = groups.title
      let text = "토론이\(groups.remainingDay)일 남았습니다."
      let attributedString = NSMutableAttributedString(string: text)
      attributedString.addAttribute(
        .foregroundColor,
        value: UIColor.cornFlowerBlue,
        range: (text as NSString).range(of: "\(groups.remainingDay)"))
      leftTimeLabel.attributedText = attributedString
      leadNameLabel.text = groups.nickname
      scoreStateLabel.text = "\(groups.leaderScore)"
      partyStateLabel.text = "\(groups.userCount)/5"
      contentLabel.text = groups.description
      guard UserDefaultHandler.shared.userName != groups.nickname else {
        self.entryButton.backgroundColor = .lightGray
        return
      }
      guard groups.isFailedGroupQuiz == false, groups.canJoinGroup == true else {
        self.entryButton.backgroundColor = .lightGray
        return
      }
    }
  }
  private let groupID: Int

  override func viewDidLoad() {
    super.viewDidLoad()
    setLayout()
    setGradientViewLayout()
    bind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    tabBarController?.tabBar.isHidden = true
    setNavigationBar(isHidden: false)
    navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    navigationController?.navigationBar.barTintColor = .white
  }

  init(groupID: Int) {
    self.groupID = groupID
    super.init()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension JoinViewController {
  private func setLayout() {
    view.adds([
      bookImageView,
      gradientImageView,
      contentView,
      entryButton
    ])
    bookImageView.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(view).offset(150)
      make.width.equalTo(208)
      make.height.equalTo(270)
    }
    gradientImageView.snp.makeConstraints { (make) in
      make.edges.equalTo(bookImageView)
    }
    contentView.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.width.equalTo(260)
      make.height.equalTo(172)
      make.top.equalTo(gradientImageView.snp.bottom).offset(0)
    }
    entryButton.snp.makeConstraints { (make) in
      make.leading.equalTo(view.safeAreaLayoutGuide)
      make.trailing.equalTo(view.safeAreaLayoutGuide)
      make.bottom.equalTo(view)
      make.height.equalTo(60)
    }
    gradientImageView.adds([
      bookTitleLabel,
      leftTimeLabel
    ])
    bookTitleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(gradientImageView).offset(16)
      make.leading.equalTo(gradientImageView).offset(13)
      make.trailing.equalTo(gradientImageView).offset(-13)
      make.height.equalTo(19)
    }
    leftTimeLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(bookTitleLabel.snp.leading)
      make.height.equalTo(18)
      make.bottom.equalTo(gradientImageView).offset(-16)
    }
  }

  private func setGradientViewLayout() {
    contentView.adds([
      leadNameLabel,
      bookIconImageView,
      partyImageView,
      partyStateLabel,
      leadScoreLabel,
      scoreStateLabel,
      participantLabel,
      leftQuoteImageView,
      contentLabel,
      rightQuoteImageView
    ])
    leadNameLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(17)
      $0.top.equalToSuperview().offset(17)
    }
    bookIconImageView.snp.makeConstraints {
      $0.top.equalTo(leadNameLabel)
      $0.trailing.lessThanOrEqualTo(70)
      $0.width.equalTo(9)
      $0.height.equalTo(9)
    }
    leadScoreLabel.snp.makeConstraints {
      $0.top.equalTo(bookIconImageView)
      $0.leading.equalTo(bookIconImageView.snp.trailing).offset(4)
    }
    scoreStateLabel.snp.makeConstraints {
      $0.top.equalTo(bookIconImageView)
      $0.leading.equalTo(leadScoreLabel.snp.trailing).offset(4)
    }
    partyImageView.snp.makeConstraints {
      $0.top.equalTo(bookIconImageView.snp.bottom).offset(6)
      $0.trailing.lessThanOrEqualTo(bookIconImageView.snp.trailing)
      $0.width.equalTo(9)
      $0.height.equalTo(9)
    }
    participantLabel.snp.makeConstraints {
      $0.top.equalTo(partyImageView)
      $0.leading.equalTo(partyImageView.snp.trailing).offset(4)
    }
    partyStateLabel.snp.makeConstraints {
      $0.top.equalTo(partyImageView)
      $0.leading.equalTo(participantLabel.snp.trailing).offset(4)
    }
    leftQuoteImageView.snp.makeConstraints {
      $0.top.equalTo(leadNameLabel.snp.bottom).offset(44)
      $0.leading.equalTo(leadNameLabel)
      $0.width.equalTo(7)
      $0.height.equalTo(7)
    }
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(partyImageView.snp.bottom).offset(45)
      $0.leading.equalTo(leftQuoteImageView.snp.trailing).offset(20)
      $0.width.equalTo(185)
      $0.height.equalTo(60)
    }
    rightQuoteImageView.snp.makeConstraints {
      $0.leading.equalTo(contentLabel.snp.trailing).offset(20)
      $0.trailing.equalTo(partyStateLabel)
      $0.width.equalTo(7)
      $0.height.equalTo(7)
      $0.top.equalTo(partyStateLabel.snp.bottom).offset(70)
    }
  }

  private func bind() {
    let viewDidLoadPublisher = PublishSubject<Void>()
    let input = JoinViewModel.Input(
      viewDidLoadPublisher: viewDidLoadPublisher,
      groupID: groupID
    )
    let output = viewModel.transform(input: input)
    output.data
      .drive(onNext: { [weak self] data in
        guard let self = self else { return }
        self.data = data
      })
      .disposed(by: disposeBag)
    viewDidLoadPublisher.onNext(())
    self.rx.dataBinder.onNext(self.data)

    entryButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        guard let groups = self.data?.groups else { return }
        let savedNickname = UserDefaultHandler.shared.userName
        let nickname = groups.nickname
        let isFailedGroupQuiz = groups.isFailedGroupQuiz
        let canJoinGroup = groups.canJoinGroup
        let isParticipated = groups.isParticipated
        guard savedNickname != nickname else {
          self.showToast("유저 본인이 개설한 모임에는 참여할 수 없습니다.")
          return
        }
        guard !isParticipated else {
          self.showToast("현재 참여하고 있는 모임입니다.")
          return
        }
        if !isFailedGroupQuiz && canJoinGroup {
          self.showToast(
            """
            5문제 중 3문제 이상 맞춰야 모임 입장 가능해요.
            기회는 단 한번! 재입장은 불가해요.
            """
          )
          DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: {
            let viewController = QuizViewController(groupID: self.groupID)
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
          })
        }
        if isFailedGroupQuiz {
          self.showToast(
            """
            2문제 이상 틀리셨어요🥺 재입장은 불가해요.
            직접 모임을 개설해 보세요:)
            """
          )
        }
        if !isFailedGroupQuiz && !canJoinGroup {
          self.showToast("인원이 꽉 찼어요:( 직접 모임을 개설해보세요🤓")
        }
      })
      .disposed(by: disposeBag)
  }
}

extension Reactive where Base: JoinViewController {
  var dataBinder: Binder<GroupInformation?> {
    return Binder(base) { base, data in
      base.data = data
    }
  }
}

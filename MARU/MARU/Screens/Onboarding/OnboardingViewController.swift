//
//  OnboardingViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/06/05.
//

import UIKit
import AuthenticationServices

import SnapKit
import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

final class OnboardingViewController: BaseViewController {
  typealias Cell = OnboardingCollectionViewCell
  typealias LoginCell = OnboardingLoginCollectionViewCell
  typealias ViewModel = OnboardingViewModel

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(cell: Cell.self)
    collectionView.register(cell: LoginCell.self)
    return collectionView
  }()

  private let pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.numberOfPages = 3
    pageControl.currentPageIndicatorTintColor = .mainBlue
    pageControl.pageIndicatorTintColor = .veryLightPink
    return pageControl
  }()

  private let didTapLoginButton = PublishSubject<(AuthType, String)>()
  private let authType = PublishSubject<AuthType>()

  private let viewModel = ViewModel()

  private let guide: [String] = [
    """
    함께 나아가는
    독서 문화 공간 마루
    """,
    """
    소통하며 쌓아가는
    독서의 즐거움
    """,
    """
    언제 어디서든
    책과 사람이 이어지는 공간
    """
  ]

  private let subGuide: [String] = [
    """
    국내 최초 온라인 독서 토론 플랫폼으로써
    책을 통해 마음을 잇는 법을 제시합니다.
    """,
    """
    독서 후 여운을 사람들과 함께 나누며
    진정한 자아를 찾아보세요.
    """
  ]

  private let image: [UIImage?] = [
    Image.illustMainBigIos01,
    Image.illustMainBigIos02
  ]

  override init() {
    super.init()
    setupCollectionView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    bind()
  }

  private func setupCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

extension OnboardingViewController {
  private func render() {
    view.add(collectionView)
    collectionView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(78)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.equalToSuperview().offset(-96)
    }
    view.add(pageControl)
    pageControl.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom)
      $0.centerX.equalToSuperview()
    }
  }

  private func bind() {
    let viewDidLoadPublisher = PublishSubject<Void>()
    let input = ViewModel.Input(
      viewDidLoad: viewDidLoadPublisher,
      didTapLoginButton: didTapLoginButton,
      authType: authType
    )

    let output = viewModel.transform(input: input)

    output.didLogin
      .drive(onNext: { [weak self] viewController in
        guard let self = self,
              let viewController = viewController,
              let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        else { return }
        viewController.modalPresentationStyle = .fullScreen
        delegate.window?.rootViewController = viewController
        self.present(viewController, animated: false)
      })
      .disposed(by: disposeBag)

    viewDidLoadPublisher.onNext(())
  }

  private func kakaoLogin() {
    UserApi.shared.loginWithKakaoAccount { [weak self] kakaoResponse, error in
      guard let self = self,
            error == nil,
            let token = kakaoResponse?.accessToken
      else { return }
      self.didTapLoginButton.onNext((.kakao, token))
      self.authType.onNext(.kakao)
    }
  }

  private func saveChatRealm(chatList: [RealmChat]) {
    chatList.forEach {
      RealmService.shared.write($0)
    }
  }
}

extension OnboardingViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
    pageControl.currentPage = pageIndex
  }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: view.frame.width, height: view.frame.height - 174)
  }
}

extension OnboardingViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 3
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = indexPath.item

    if item == 2 {
      let cell: LoginCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

      cell.bind(guide: guide[item])

      cell.rx.didTapAppleLoginButton
        .subscribe(onNext: { [weak self] _ in
          guard let self = self else { return }
          let appleIdRequest = ASAuthorizationAppleIDProvider().createRequest()
          let controller = ASAuthorizationController(authorizationRequests: [appleIdRequest])
          controller.delegate = self
          controller.presentationContextProvider = self
          controller.performRequests()
        })
        .disposed(by: cell.disposeBag)

      cell.rx.didTapKakaoLoginButton
        .subscribe(onNext: { [weak self] _ in
          self?.kakaoLogin()
        })
        .disposed(by: cell.disposeBag)

      return cell
    }

    let cell: Cell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.bind(guide: guide[item], subGuide: subGuide[item], image: image[item])
    return cell
  }
}

extension OnboardingViewController: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController,
                               didCompleteWithAuthorization authorization: ASAuthorization) {
    guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
          let identifyToken = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8)
    else { return }
    didTapLoginButton.onNext((.apple, identifyToken))
    authType.onNext(.apple)
  }
}

extension OnboardingViewController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}

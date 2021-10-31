//
//  BookAlertViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/22.
//
//  서재에 담아두기 팝업화면용
//
import UIKit
import RxSwift
import RxCocoa

final class BookAlertViewController: UIViewController {

  private let popUpView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 9
    $0.layer.masksToBounds = true
  }

  private let stateImageView = UIImageView().then {
    $0.layer.masksToBounds = true
  }

  private let titleLabel = UILabel().then {
    $0.text = "(책 제목) 책이"
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 13, weight: .regular)
  }

  private let stateLabel = UILabel().then {
    $0.text = "성공적으로 서재에 담겼습니다."
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 13, weight: .regular)
  }

  private let submitButton = UIButton().then {
    $0.backgroundColor = .mainBlue
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    $0.setTitle("확인", for: .normal)
    $0.setTitleColor(.white, for: .normal)
  }
  private var data: BookModel?
  private let viewModel = BookAlertViewModel()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    render()
  }
  init(_ image: UIImage,
       _ guideText: String,
       _ subGuideText: String,
       _ bookModel: BookModel) {
    super.init(nibName: nil, bundle: nil)
    stateImageView.image = image
    titleLabel.text = guideText
    stateLabel.text = subGuideText
    data = bookModel
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension BookAlertViewController {
  private func bind() {
    // MARK: - 확인버튼 탭 -> dismiss처리
    submitButton.rx.tap
      .subscribe( onNext: { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: disposeBag)

    let didTapSubmitButton = submitButton.rx.tap
      .map { [weak self] _ -> AlertButtonDTO in
        guard let self = self,
              let author = self.data?.author,
              let category = self.data?.category,
              let imageURL = self.data?.imageURL,
              let isbn = self.data?.isbn,
              let title = self.data?.title
        else { return AlertButtonDTO(author: "", category: "", imageURL: "", isbn: 0, title: "") }
        return AlertButtonDTO(author: author, category: category, imageURL: imageURL, isbn: isbn, title: title)
      }

    let input = BookAlertViewModel.Input(didTapSubmitButton: didTapSubmitButton)
    let output = viewModel.transform(input: input)

    output.isSuccess
      .subscribe(onNext: { [weak self] isSuccess in
        guard let self = self else { return }
        if !isSuccess {
          self.showToast("error")
        }
        self.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
  }
  private func render() {
    view.backgroundColor = .black.withAlphaComponent(0.7)
    view.add(popUpView)
    popUpView.adds([
      stateImageView,
      titleLabel,
      stateLabel,
      submitButton
    ])

    popUpView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(200)
      make.height.equalTo(220)
      make.width.equalTo(252)
    }

    stateImageView.snp.makeConstraints { make in
      make.centerX.equalTo(popUpView)
      make.leading.equalTo(popUpView).offset(100)
      make.top.equalTo(popUpView).offset(20)
      make.size.equalTo(45)
    }

    titleLabel.snp.makeConstraints { make in
      make.centerX.equalTo(stateImageView)
      make.leading.equalTo(popUpView).offset(30)
      make.top.equalTo(stateImageView.snp.bottom).offset(20)
    }

    stateLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(6)
      make.leading.equalTo(popUpView).offset(48)
    }

    submitButton.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
  }
}

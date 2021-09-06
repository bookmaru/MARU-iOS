//
//  EvaluateViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/04.
//
//
import UIKit
import RxSwift
import RxCocoa

final class EvaluateViewController: UIViewController {
  private let popUpView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 9
    $0.layer.masksToBounds = true
  }
  private let titleLabel = UILabel().then {
    $0.text = "모임은 어떠셨나요?"
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 18, weight: .bold)
  }
  private let firstScoreButton = UIButton().then {
    $0.setImage(Image.star5, for: .normal)
    $0.setImage(Image.star1, for: .selected)
    $0.addTarget(self, action: #selector(scoreButtonDidTap), for: .touchUpInside)
    $0.tag = 1
  }
  private let secondScoreButton = UIButton().then {
    $0.setImage(Image.star5, for: .normal)
    $0.setImage(Image.star1, for: .selected)
    $0.addTarget(self, action: #selector(scoreButtonDidTap), for: .touchUpInside)
    $0.tag = 2
  }
  private let thirdScoreButton = UIButton().then {
    $0.setImage(Image.star5, for: .normal)
    $0.setImage(Image.star1, for: .selected)
    $0.addTarget(self, action: #selector(scoreButtonDidTap), for: .touchUpInside)
    $0.tag = 3
  }
  private let fourthScoreButton = UIButton().then {
    $0.setImage(Image.star5, for: .normal)
    $0.setImage(Image.star1, for: .selected)
    $0.addTarget(self, action: #selector(scoreButtonDidTap), for: .touchUpInside)
    $0.tag = 4
  }
  private let fifthScoreButton = UIButton().then {
    $0.setImage(Image.star5, for: .normal)
    $0.setImage(Image.star1, for: .selected)
    $0.addTarget(self, action: #selector(scoreButtonDidTap), for: .touchUpInside)
    $0.tag = 5
  }
  private let subTitleLabel = UILabel().then {
    $0.text = "뫄뫄뫄님의 별점을 평가해주세요."
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    // 사용자 이름만 bold처리 해줄 것
    // 나머지 브랜치랑 머지되면 이런 주석은 todo로 바꿔서 넣겠음
  }
  private let submitButton = UIButton().then {
    $0.backgroundColor = .lightGray
    $0.isEnabled = false
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    $0.setTitle("확인", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.addTarget(self, action: #selector(submitButtonDidTap), for: .touchUpInside)
  }
  var leaderName: String?
  var score: Int = 0
  let disposeBag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }
}

extension EvaluateViewController {
  private func render() {
    view.backgroundColor = .black.withAlphaComponent(0.7)
    view.add(popUpView)
    popUpView.adds([
      titleLabel,
      firstScoreButton,
      secondScoreButton,
      thirdScoreButton,
      fourthScoreButton,
      fifthScoreButton,
      subTitleLabel,
      submitButton
    ])
    popUpView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(200)
      make.height.equalTo(220)
      make.width.equalTo(252)
    }
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalTo(popUpView)
      make.leading.equalTo(popUpView).offset(56)
      make.top.equalTo(popUpView).offset(20)
    }
    firstScoreButton.snp.makeConstraints { make in
      make.size.equalTo(30)
      make.leading.equalTo(popUpView).offset(40)
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
    }
    secondScoreButton.snp.makeConstraints { make in
      make.size.equalTo(30)
      make.leading.equalTo(firstScoreButton.snp.trailing).offset(5)
      make.top.equalTo(firstScoreButton.snp.top)
    }
    thirdScoreButton.snp.makeConstraints { make in
      make.size.equalTo(30)
      make.leading.equalTo(secondScoreButton.snp.trailing).offset(5)
      make.top.equalTo(secondScoreButton.snp.top)
    }
    fourthScoreButton.snp.makeConstraints { make in
      make.size.equalTo(30)
      make.leading.equalTo(thirdScoreButton.snp.trailing).offset(5)
      make.top.equalTo(thirdScoreButton.snp.top)
    }
    fifthScoreButton.snp.makeConstraints { make in
      make.size.equalTo(30)
      make.leading.equalTo(fourthScoreButton.snp.trailing).offset(5)
      make.top.equalTo(fourthScoreButton.snp.top)
    }
    subTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(firstScoreButton.snp.bottom).offset(20)
      make.centerX.equalTo(popUpView)
    }
    submitButton.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
  }
  @objc func submitButtonDidTap() {
    // MARK: - 방장 평가 통신 진행
    self.dismiss(animated: true, completion: nil)
  }
  // MARK: - 버튼 값(방장 평가 점수) 컨트롤
  @objc func scoreButtonDidTap(sender: UIButton) {
    switch sender.tag {
    case 1:
      sender.isSelected = true
      secondScoreButton.isSelected = false
      thirdScoreButton.isSelected = false
      fourthScoreButton.isSelected = false
      fifthScoreButton.isSelected = false
      submitButton.backgroundColor = .mainBlue
      submitButton.isEnabled = true
    case 2:
      sender.isSelected = true
      firstScoreButton.isSelected = true
      thirdScoreButton.isSelected = false
      fourthScoreButton.isSelected = false
      fifthScoreButton.isSelected = false
      submitButton.backgroundColor = .mainBlue
      submitButton.isEnabled = true
    case 3:
      sender.isSelected = true
      firstScoreButton.isSelected = true
      secondScoreButton.isSelected = true
      fourthScoreButton.isSelected = false
      fifthScoreButton.isSelected = false
      submitButton.backgroundColor = .mainBlue
      submitButton.isEnabled = true
    case 4:
      sender.isSelected = true
      firstScoreButton.isSelected = true
      secondScoreButton.isSelected = true
      thirdScoreButton.isSelected = true
      fifthScoreButton.isSelected = false
      submitButton.backgroundColor = .mainBlue
      submitButton.isEnabled = true
    case 5:
      sender.isSelected = true
      firstScoreButton.isSelected = true
      secondScoreButton.isSelected = true
      thirdScoreButton.isSelected = true
      fourthScoreButton.isSelected = true
      submitButton.backgroundColor = .mainBlue
      submitButton.isEnabled = true
    default:
      break
    }
  }
}

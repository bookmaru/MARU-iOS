//
//  ImagePopUpView.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ImagePopUpView: UIViewController {
  private let popUpView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 9
  }
  private let titleLabel = UILabel().then {
    $0.text = "모임은 어떠셨나요?"
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 18, weight: .bold)
  }
  private let firstScoreButton = UIButton().then {
    $0.setImage(Image.star5, for: .normal)
  }
  private let secondScoreButton = UIButton().then {
    $0.setImage(Image.star5, for: .normal)
  }
  private let thirdScoreButton = UIButton().then {
    $0.setImage(Image.star5, for: .normal)
  }
  private let fourthScoreButton = UIButton().then {
    $0.setImage(Image.star5, for: .normal)
  }
  private let fifthScoreButton = UIButton().then {
    $0.setImage(Image.star5, for: .normal)
  }
  private let subTitleLabel = UILabel().then {
    $0.text = "뫄뫄뫄님의 별점을 평가해주세요."
    $0.textAlignment = .center
  }
  private let submitButton = UIButton().then {
    $0.backgroundColor = .mainBlue
    $0.setTitle("확인", for: .normal)
    $0.setTitleColor(.white, for: .normal)
  }
  var leaderName: String?
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }
  
}

extension ImagePopUpView {
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
      make.leading.equalTo(firstScoreButton.snp.trailing).offset(5)
      make.top.equalTo(firstScoreButton.snp.top)
    }
    fourthScoreButton.snp.makeConstraints { make in
      make.size.equalTo(30)
      make.leading.equalTo(firstScoreButton.snp.trailing).offset(5)
      make.top.equalTo(firstScoreButton.snp.top)
    }
    fifthScoreButton.snp.makeConstraints { make in
      make.size.equalTo(30)
      make.leading.equalTo(firstScoreButton.snp.trailing).offset(5)
      make.top.equalTo(firstScoreButton.snp.top)
    }
    subTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(firstScoreButton.snp.bottom).offset(20)
      make.centerX.equalTo(popUpView)
    }
    submitButton.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.bottom.equalTo(popUpView).offset(0)
      make.leading.equalTo(popUpView).offset(0)
      make.trailing.equalTo(popUpView).offset(0)
    }
  }
}

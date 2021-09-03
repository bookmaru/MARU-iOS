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
  
  
}

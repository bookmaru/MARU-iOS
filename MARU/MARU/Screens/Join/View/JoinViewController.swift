//
//  JoinViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/06/21.
//

import UIKit

import Then
import RxSwift
import RxCocoa

final class JoinViewController: BaseViewController {
  private let bookImageView = UIImageView().then {
    $0.image = Image.testImage
  }
  private let gradientImageView = UIImageView().then {
    $0.image = Image.gradientImage
  }
  private let bookTitleLabel = UILabel().then {
    $0.text = "엄성용교수가만안도"
    $0.numberOfLines = 2
    $0.font = .boldSystemFont(ofSize: 16)
    $0.textColor = .white
  }
  private let leftTimeLabel = UILabel().then {
    $0.text = "토론이 1-7일 남았습니다."
    $0.font = .boldSystemFont(ofSize: 15)
    $0.textColor = .white
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
    $0.text = "방장 평점 5.0"
    $0.font = .systemFont(ofSize: 13, weight: .bold)
    $0.textAlignment = .left
    $0.textColor = .mainBlue
  }
  private let participantLabel = UILabel().then {
    $0.text = "현재 인원 5/5"
    $0.font = .systemFont(ofSize: 13, weight: .bold)
    $0.textAlignment = .left
    $0.textColor = .mainBlue
  }
  private let leftQuoteImageView = UIImageView().then {
    $0.image = Image.quotationMarkLeft
  }
  private let contentLabel = VerticalAlignLabel().then {
    $0.font = RIDIBatangFont.medium.of(size: 12)
    $0.textAlignment = .center
    $0.numberOfLines = 3
    $0.text = """
    식물책표지가되게예쁘네네네네네네
    무슨내용일까까까가가가가가가가가
    와랄랄라와랄랄라와랄랄라와랄라라
    """
  }
  private let rightQuoteImageView = UIImageView().then {
    $0.image = Image.quotationMarkRight
  }
  private let entryButton = UIButton().then {
    $0.backgroundColor = .mainBlue
    $0.setTitle("참여하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    setLayout()
    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: true)
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
      make.top.equalTo(view).offset(130)
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
      make.bottom.equalTo(view.safeAreaLayoutGuide)
      //  make.top.equalTo(contentView.snp.bottom).offset(90)
      make.height.equalTo(49)
    }
    gradientImageView.adds([
      bookTitleLabel,
      leftTimeLabel
    ])
    bookTitleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(gradientImageView).offset(16)
      make.leading.equalTo(gradientImageView).offset(13)
      make.height.equalTo(19)
    }
    leftTimeLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(bookTitleLabel.snp.leading)
      make.height.equalTo(18)
      make.bottom.equalTo(gradientImageView).offset(-16)
    }
    contentView.adds([
      leadNameLabel,
      bookIconImageView,
      partyImageView,
      leadScoreLabel,
      participantLabel,
      leftQuoteImageView,
      contentLabel,
      rightQuoteImageView
    ])
  }
  private func setGradientViewLayout() {
  }
}

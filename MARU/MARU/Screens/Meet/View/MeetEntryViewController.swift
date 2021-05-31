//
//  MeetEntryViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/05/03.
//

import UIKit

import Then
import RxSwift
import RxCocoa
import SnapKit

final class MeetEntryViewController: BaseViewController {
  private let bookImageView = UIImageView().then {
    $0.image = UIImage(named: "gradientImage")
  }
  
  private let introductionView = UIView().then {
    $0.layer.applyShadow()
  }
  
  private let bookTitleLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.text = "책 제목 들어갈 공간 2줄까지 처리 가능"
  }
  
  private let authorLabel = UILabel().then {
    $0.text = "작가이름"
  }
  
  private let ownerLabel = UILabel().then {
    $0.text = "방장이름"
  }
  
  private let timeLabel = UILabel().then {
    $0.text = "토론이 n일 남았습니다."
  }
  
  private let scoreLabel = UILabel().then {
    $0.text = "방장 평점"
  }
  
  private let countLabel = UILabel().then {
    $0.text = "현재 인원"
  }
  
  private let bookImage = UIImageView().then {
    $0.image = UIImage(named: "searchIcScore")
  }
  
  private let memberImage = UIImageView().then {
    $0.image = UIImage(named: "searchIcMember")
  }
  
  private let entryButton = UIButton().then {
    $0.setTitle("참여하기", for: .normal)
    $0.backgroundColor = UIColor.cornflowerBlue
  }
  
  private let welcomingTextLabel = UILabel().then{
    $0.text = "소개 문구"
    $0.numberOfLines = 3
  }
  
  private let disposeBag = DisposeBag()
  private let viewModel = MeetEntryViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}


extension MeetEntryViewController {
  
  func constraints() {
    view.add(bookImageView)
    view
  }
  func bind() {
    let output = viewModel.transform(input: .init(entryButton: entryButton))
  }
}


//
//  CreateQuizViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/09.
//

import UIKit
import SnapKit

class CreateQuizViewController: BaseViewController {
  private var quizTableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .white
  }
  private var headerView = UIView()
  // 책 표지 이미지 들어가는 컨텐츠 뷰 추가로 넣어줘야함
  private var headerLabel = UILabel().then {
    $0.text = "한줄 소개"
  }
  private var introTextView = UITextView().then {
    $0.layer.cornerRadius = 8.0
  }
  private var footerLabel = UILabel().then {
    $0.text = "퀴즈 작성"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

//
//  DiaryViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/10/11.
//

import UIKit

final class DiaryViewController: BaseViewController {

  override var hidesBottomBarWhenPushed: Bool {
    get { navigationController?.topViewController == self }
    set { super.hidesBottomBarWhenPushed = newValue }
  }

  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let dateLabel = UILabel()

  override init() {
    super.init()

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

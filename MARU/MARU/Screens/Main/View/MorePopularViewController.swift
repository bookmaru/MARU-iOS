//
//  MorePopularViewController.swift
//  MARU
//
//  Created by psychehose on 2021/05/29.
//

import UIKit

class MorePopularViewController: BaseViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: false)
  }
}

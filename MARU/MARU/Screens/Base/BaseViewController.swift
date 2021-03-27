//
//  BaseViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    defaultUI()
  }

}

extension BaseViewController {
  private func defaultUI() {
    view.backgroundColor = .white
  }
}

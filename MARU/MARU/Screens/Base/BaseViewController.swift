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
    setNavigationItems()
  }

}

extension BaseViewController {
  private func defaultUI() {
    view.backgroundColor = .white
  }
  private func setNavigationItems() {
    if navigationController?.children.count ?? 0 > 1 {
      let backImage = UIImage(systemName:
                                "chevron.backward")?
        .withTintColor(.black)
        .withRenderingMode(.alwaysOriginal)

      let backButton = UIBarButtonItem(image: backImage,
                                       style: .plain,
                                       target: self,
                                       action: #selector(didBack))
        navigationItem.leftBarButtonItem = backButton
      }
  }

  func setNavigationBar(isHidden: Bool) {
    navigationController?.setNavigationBarHidden(isHidden, animated: false)
  }

  @objc func didBack() {
    navigationController?.popViewController(animated: true)
  }
}

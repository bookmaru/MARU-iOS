//
//  ProfileChangeViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/08.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class ProfileChangeViewController: BaseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  private func render() {
  }
}

extension ProfileChangeViewController {
  @objc func didTapExitButton() {
    self.dismiss(animated: true, completion: nil)
  }
}

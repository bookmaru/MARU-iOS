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

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    defaultUI()
    setNavigationItems()
    setupAppearance()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    self.view.endEditing(true)
  }
}

extension BaseViewController {
  private func defaultUI() {
    view.backgroundColor = .white
  }
  private func setNavigationItems() {
    if navigationController?.children.count ?? 0 > 1 {
      let backImage = UIImage(systemName: "chevron.backward")?
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
    navigationController?.setNavigationBarHidden(isHidden, animated: true)
  }

  @objc func didBack() {
    navigationController?.popViewController(animated: true)
  }
}
extension BaseViewController: UINavigationBarDelegate {
  private func setupAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .white
    appearance.shadowColor = .white
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
  }
}

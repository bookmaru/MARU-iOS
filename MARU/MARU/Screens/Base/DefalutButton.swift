//
//  DefalutButton.swift
//  MARU
//
//  Created by 김호세 on 2021/12/14.
//

import UIKit

class DefalutButton: UIButton {

  override var isEnabled: Bool {
    didSet {
      if isEnabled == true {
        layer.borderColor = UIColor.mainBlue.cgColor
      } else {
        layer.borderColor = UIColor.veryLightGray.cgColor
      }
    }
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureButton()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension DefalutButton {
  private func configureButton() {
    layer.borderWidth = 1
    layer.borderColor = UIColor.mainBlue.cgColor
    layer.cornerRadius = 13
  }
}

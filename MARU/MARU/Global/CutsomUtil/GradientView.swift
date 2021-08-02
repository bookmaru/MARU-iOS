//
//  GradientView.swift
//  MARU
//
//  Created by 오준현 on 2021/07/21.
//

import UIKit

final class GradientView: UIView {

  private let gradient: CAGradientLayer = CAGradientLayer()

  init(
    startColor: UIColor,
    endColor: UIColor,
    startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
    endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0)
  ) {
    super.init(frame: .zero)
    gradient.colors = [startColor.cgColor, endColor.cgColor]
    gradient.locations = [0.0, 1.0]
    gradient.startPoint = startPoint
    gradient.endPoint = endPoint

    layer.addSublayer(gradient)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
      super.layoutSubviews()
      gradient.frame = bounds
  }
}

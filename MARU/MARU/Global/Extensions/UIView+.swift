//
//  UIView+.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

import UIKit

import SnapKit

extension UIView {

  @discardableResult
  func add<T: UIView>(_ subview: T, then closure: ((T) -> Void)? = nil) -> T {
    addSubview(subview)
    closure?(subview)
    return subview
  }

  @discardableResult
  func adds<T: UIView>(_ subviews: [T], then closure: (([T]) -> Void)? = nil) -> [T] {
    subviews.forEach { addSubview($0) }
    closure?(subviews)
    return subviews
  }

  func applyShadow(color: UIColor, alpha: Float,
                   shadowX: CGFloat, shadowY: CGFloat, blur: CGFloat) {
    let shadowView = UIView()
    add(shadowView) {
      $0.snp.makeConstraints {
        $0.edges.equalTo(self)
      }
    }
    layer.masksToBounds = false
    layer.applyShadow(color: color,
                      alpha: alpha,
                      shadowX: shadowX,
                      shadowY: shadowY,
                      blur: blur)
  }
  func applyQuizViewShadow() {
    self.backgroundColor = .white
    self.layer.borderWidth = 0.5
    self.layer.cornerRadius = 5
    self.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = .zero
    self.layer.shadowRadius = 1.5
    self.layer.shadowOpacity = 0.2
    self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
  }
}

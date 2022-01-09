//
//  NSMutableAttributedString+.swift
//  MARU
//
//  Created by 이윤진 on 2022/01/10.
//

import Foundation
import UIKit

extension NSMutableAttributedString {

  func bold(string: String, fontSize: CGFloat) -> NSMutableAttributedString {
    let font = UIFont.boldSystemFont(ofSize: fontSize)
    let attributes: [NSAttributedString.Key: Any] = [.font: font]
    self.append(NSAttributedString(string: string, attributes: attributes))
    return self
  }

  func regular(string: String, fontSize: CGFloat) -> NSMutableAttributedString {
    let font = UIFont.systemFont(ofSize: fontSize)
    let attributes: [NSAttributedString.Key: Any] = [.font: font]
    self.append(NSAttributedString(string: string, attributes: attributes))
    return self
  }
}

//
//  VerticalAlignLabel.swift
//  MARU
//
//  Created by JH_OH on 2021/04/17.
//

import UIKit

final class VerticalAlignLabel: UILabel {
  override func drawText(in rect: CGRect) {
    guard let labelText = text else { return super.drawText(in: rect) }
    let attributedText = NSAttributedString(
      string: labelText,
      attributes: [NSAttributedString.Key.font: font!]
    )
    var newRect = rect
    newRect.size.height = attributedText.boundingRect(
      with: rect.size,
      options: .usesLineFragmentOrigin,
      context: nil
    ).size.height
    if numberOfLines != 0 {
      newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
    }
    super.drawText(in: newRect)
  }
}

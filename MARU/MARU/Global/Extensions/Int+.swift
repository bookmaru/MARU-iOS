//
//  Int+.swift
//  MARU
//
//  Created by 오준현 on 2021/05/08.
//

import UIKit

extension Int {
  var string: String {
    "\(self)"
  }

  var calculatedWidth: CGFloat { CGFloat(self) * ScreenSize.width / 375 }

  var calculatedHeight: CGFloat { CGFloat(self) * ScreenSize.height / 667 }

  var radians: CGFloat {
    return CGFloat(self) * .pi / 180
  }
}

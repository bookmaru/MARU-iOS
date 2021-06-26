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

  var calculatedWidth: CGFloat { CGFloat(self / 375) * ScreenSize.width }

  var calculatedHeight: CGFloat { CGFloat(self / 667) * ScreenSize.height }

}

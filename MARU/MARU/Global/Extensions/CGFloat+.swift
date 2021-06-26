//
//  CGFloat+.swift
//  MARU
//
//  Created by 오준현 on 2021/06/26.
//

import UIKit

extension CGFloat {

  var calculatedWidth: CGFloat { self / 375 * ScreenSize.width }

  var calculatedHeight: CGFloat { self / 667 * ScreenSize.height }
}

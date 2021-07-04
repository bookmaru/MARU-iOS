//
//  CGFloat+.swift
//  MARU
//
//  Created by 오준현 on 2021/06/26.
//

import UIKit

extension CGFloat {

  var calculatedWidth: CGFloat { self * ScreenSize.width / 375 }

  var calculatedHeight: CGFloat { self * ScreenSize.height / 667 }
}

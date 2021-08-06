//
//  Date+.swift
//  MARU
//
//  Created by 오준현 on 2021/08/07.
//

import Foundation

extension Date {
  var isExpired: Bool {
    return self < Date(timeInterval: -60 * 60 * 24, since: Date())
  }
}

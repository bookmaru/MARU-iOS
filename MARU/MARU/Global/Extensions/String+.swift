//
//  String+.swift
//  MARU
//
//  Created by 오준현 on 2021/05/08.
//

import Foundation

extension String {
  var intValue: Int {
    return Int(self) ?? -1
  }
}

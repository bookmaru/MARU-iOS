//
//  RIDIBatangFont.swift
//  MARU
//
//  Created by JH_OH on 2021/04/17.
//

import UIKit

enum RIDIBatangFont: String {

  case medium = "RIDIBatang"

  func of(size: CGFloat) -> UIFont {
    guard let font = UIFont(name: self.rawValue, size: size) else {
      return .systemFont(ofSize: size)
    }
    return font
  }

}

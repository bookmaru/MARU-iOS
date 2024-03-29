//
//  UIColor+.swift
//  MARU
//
//  Created by JH_OH on 2021/04/17.
//

import UIKit

extension UIColor {
  func hexStringToUIColor (hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if cString.hasPrefix("#") {
      cString.remove(at: cString.startIndex)
    }

    if cString.count != 6 {
      return UIColor.gray
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }

  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }

  convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }

  func as1ptImage() -> UIImage {
    UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
    setFill()
    UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
    let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    UIGraphicsEndImageContext()
    return image
  }

  @nonobjc class var black: UIColor {
    return UIColor(white: 52.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var veryLightPink: UIColor {
    return UIColor(white: 209.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var ligthGray: UIColor {
    return UIColor(white: 235.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var brownishGrey: UIColor {
    return UIColor(white: 112.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var blackTwo: UIColor {
    return UIColor(white: 44.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var orangeyRed: UIColor {
    return UIColor(red: 1.0, green: 60.0 / 255.0, blue: 52.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var negative: UIColor {
    return UIColor(red: 224.0 / 255.0, green: 83.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var brownGrey: UIColor {
    return UIColor(white: 178.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var bgLightgray: UIColor {
    return UIColor(white: 250.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var mainBlue: UIColor {
    return UIColor(red: 65.0 / 255.0, green: 105.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var white: UIColor {
    return UIColor(white: 1.0, alpha: 1.0)
  }
  @nonobjc class var brownGreyTwo: UIColor {
    return UIColor(white: 159.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var veryLightPinkThree: UIColor {
    return UIColor(white: 240.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var black22: UIColor {
    return UIColor(white: 34.0 / 255.0, alpha: 0.22)
  }
  @nonobjc class var veryLightPinkFour: UIColor {

    return UIColor(white: 220.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var brownGreyThree: UIColor {
    return UIColor(white: 132.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var brownGreyFour: UIColor {
    return UIColor(white: 130.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var subText: UIColor {
    return UIColor(white: 194.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var carolinaBlue: UIColor {
      return UIColor(red: 131.0 / 255.0, green: 172.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
  @nonobjc class var cornFlowerBlue: UIColor {
    return UIColor(red: 131.0 / 255.0, green: 172.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var black16: UIColor {
      return UIColor(white: 0.0, alpha: 0.16)
    }
  @nonobjc class var quizBackgroundColor: UIColor {
    return UIColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1)
  }
  @nonobjc class var black30: UIColor {
      return UIColor(white: 0.0, alpha: 0.3)
  }
  @nonobjc class var veryLightGray: UIColor {
    return UIColor(red: 222 / 255, green: 222 / 255, blue: 222 / 255)
  }
}

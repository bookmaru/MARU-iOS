//
//  UIImageView+.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/01.
//

import UIKit.UIImageView

import Kingfisher

extension UIImageView {

  func setImage(from url: String, _ defaultImage: UIImage) {
    self.kf.indicatorType = .activity
    self.kf.setImage(with: URL(string: url)!,
                     placeholder: UIImage(),
                     options: [.transition(.fade(1))],
                     progressBlock: nil)
  }

  public func imageFromUrl(_ urlString: String?, defaultImgPath: String?) {
    let tmpURL: String? = urlString == nil ? "" : urlString
    if let url = tmpURL,
       !url.isEmpty {
      kf.setImage(
        with: URL(string: url),
        options: [
          .transition(ImageTransition.fade(0.5)),
          .backgroundDecode,
          .alsoPrefetchToMemory,
          .cacheMemoryOnly
        ]
      )
    } else {
      kf.setImage(
        with: URL(string: defaultImgPath ?? ""),
        options: [
          .transition(ImageTransition.fade(0.5)),
          .backgroundDecode,
          .alsoPrefetchToMemory,
          .cacheMemoryOnly
        ]
      )
    }
  }
}

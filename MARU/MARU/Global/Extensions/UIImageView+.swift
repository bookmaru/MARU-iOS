//
//  UIImageView+.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/01.
//

import UIKit.UIImageView

import Kingfisher

extension UIImageView {

  /// Kingfisher 이미지 처리
  /// - Parameters:
  ///   - url: 이미지 URL
  ///   - defaultImage: 디폴트 이미지!!
  func image(url: String, defaultImage: UIImage = UIImage()) {
    kf.indicatorType = .activity

    // MARK: - 의견 구함
    /*
     배경: 현재 지금 새로 나온 모임에 있는 모임들 중 몇개가 imageURL = www.naver.com! 이런식으로 되어있어서
     guard문에 안걸립니다. 사실 실제 서버에서 저렇게 날라올 거 같지는 않은데 하얀배경으로 나오는 게 약간 열받아서
     일단 이렇게 처리해놓았습니다.
     
     본론: 혹시 www.naver.com! 같이 url 스럽게 날아오지만 실제 데이터가 아닌 경우에 어떻게 하는 게 좋을까요?
     1. 서버에서 이런 거 안 준다고 가정하고 한다.
     2. 예외처리 하는 방법을 찾아본다.
     3. 기타의견
     */

    guard let url = URL(string: url),
          let _ = try? Data(contentsOf: url)
    else {
      image = defaultImage
      backgroundColor = .black.withAlphaComponent(0.05)
      return
    }
    kf.setImage(
      with: url,
      placeholder: .none,
      options: [
        .transition(ImageTransition.fade(0.5)),
        .backgroundDecode,
        .alsoPrefetchToMemory,
        .cacheMemoryOnly
      ]
    )
  }

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

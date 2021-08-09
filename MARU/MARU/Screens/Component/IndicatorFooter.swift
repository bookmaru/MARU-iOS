//
//  IndicatorFooter.swift
//  MARU
//
//  Created by psychehose on 2021/08/12.
//

import UIKit

final class IndicatorFooter: UICollectionReusableView {
  var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureComponent()
    configure()
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
  private func configureComponent() {
    indicatorView.startAnimating()
    indicatorView.hidesWhenStopped = true
  }
  private func configure() {
    add(indicatorView)

    indicatorView.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 40, height: 40))
      make.center.equalToSuperview()
    }
  }
}

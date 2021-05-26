//
//  MaruSearchView.swift
//  MARU
//
//  Created by psychehose on 2021/05/05.
//

import UIKit

import RxSwift
import RxCocoa

protocol SearchTextFieldDelegate: AnyObject {
  func enterTextField()
}

final class MaruSearchView: UIView {

  let searchImage = UIImageView().then {
    $0.image = Image.mainIcSearch
  }

  let searchTextField = UITextField().then {
    $0.text = ""
    $0.placeholder  = "책 제목을 입력해주세요."
    $0.tintColor = .black
    $0.textAlignment = .left
    $0.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
  }
  var width: CGFloat
  var height: CGFloat
  weak var delegate: SearchTextFieldDelegate?

  init(width: CGFloat, height: CGFloat) {
    self.width = width
    self.height = height
    super.init(frame: .zero)
    applyProperty()
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func setupView() {
    self.adds([searchImage, searchTextField])

    self.translatesAutoresizingMaskIntoConstraints = false
    self.widthAnchor.constraint(equalToConstant: width).isActive = true
    self.heightAnchor.constraint(equalToConstant: height).isActive = true

    searchImage.snp.makeConstraints { make in
      make.top.equalTo(self.snp.top).inset(11)
      make.leading.equalTo(self.snp.leading).inset(10)
      make.height.equalTo(16)
      make.width.equalTo(16)
    }
    searchTextField.snp.makeConstraints { make in
      make.top.equalTo(self.snp.top).inset(11)
      make.leading.equalTo(searchImage.snp.trailing).inset(-8)
      make.trailing.equalTo(self.snp.trailing)
      make.height.equalTo(16)
    }

  }
}

extension MaruSearchView {

  private func applyProperty() {
    applyShadow(color: .black,
                alpha: 0.1,
                shadowX: 0,
                shadowY: 0,
                blur: 15/2)

    self.backgroundColor = .white
    self.layer.borderWidth = 1
    self.layer.cornerRadius = 8
    self.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
  }
}
extension MaruSearchView: UITextFieldDelegate, SearchTextFieldDelegate {
  func enterTextField() {}
  }

//
//  MaruSearchView.swift
//  MARU
//
//  Created by psychehose on 2021/05/05.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

protocol SearchTextFieldDelegate: AnyObject {
  func tapTextField()
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
    $0.addTarget(self, action: #selector(tapTextField), for: .editingDidBegin)
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
    adds([searchImage, searchTextField])

    translatesAutoresizingMaskIntoConstraints = false
    widthAnchor.constraint(equalToConstant: width).isActive = true
    heightAnchor.constraint(equalToConstant: height).isActive = true

    searchImage.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(self.snp.leading).inset(6)
      make.height.equalTo(20)
      make.width.equalTo(20)
    }
    searchTextField.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(searchImage.snp.trailing).inset(-5)
      make.trailing.equalTo(self.snp.trailing)
      make.height.equalTo(15)
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

    backgroundColor = .white
    layer.borderWidth = 1
    layer.cornerRadius = 8
    layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
  }
}
extension MaruSearchView: UITextFieldDelegate, SearchTextFieldDelegate {
  @objc func tapTextField() {
    delegate?.tapTextField()
  }
}

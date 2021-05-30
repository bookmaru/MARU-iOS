//
//  SectionHeader.swift
//  MARU
//
//  Created by psychehose on 2021/05/28.
//

import UIKit
protocol ButtonDelegate: AnyObject {
  func tapButton()
}

final class SectionHeader: UICollectionReusableView {
  static let sectionHeaderElementKind = "section-header-element-kind"

  let titleLabel = UILabel().then {
    $0.sizeToFit()
    $0.adjustsFontSizeToFitWidth = true
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.text = "defalut"
  }
  let moveButton = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.right")?.withTintColor(.black,
                                                                    renderingMode: .alwaysOriginal),
                for: .normal)
    $0.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
  }
  weak var delegate: ButtonDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
}
extension SectionHeader {
    func configure() {
      add(titleLabel)
      add(moveButton)

      titleLabel.snp.makeConstraints { make in
        make.leading.equalToSuperview()
        make.centerY.equalToSuperview()
      }
      moveButton.snp.makeConstraints { make in
        make.leading.equalTo(titleLabel.snp.trailing).inset(-5)
        make.centerY.equalToSuperview()
        make.size.equalTo(CGSize(width: 19, height: 19))
      }

    }
  func hideButton(isHidden: Bool) {
    moveButton.isHidden = isHidden
  }
  func setupText(text: String) {
    titleLabel.text = text
  }
}

extension SectionHeader: ButtonDelegate {
  @objc func tapButton() {
    delegate?.tapButton()
  }
}

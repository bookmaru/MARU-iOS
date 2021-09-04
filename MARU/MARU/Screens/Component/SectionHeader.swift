//
//  SectionHeader.swift
//  MARU
//
//  Created by psychehose on 2021/05/28.
//

import UIKit
protocol ButtonDelegate: AnyObject {
  func didPressButtonInHeader(_ tag: Int)
}

final class SectionHeader: UICollectionReusableView {
  static let sectionHeaderElementKind = "section-header-element-kind"

  private let titleLabel = UILabel().then {
    $0.sizeToFit()
    $0.adjustsFontSizeToFitWidth = true
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.text = "defalut"
  }
  private let moveButton = UIButton().then {
    let image = UIImage(systemName: "chevron.right")
    $0.setImage(image?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
    $0.addTarget(self, action: #selector(tapButtonInHeader(_:)), for: .touchUpInside)
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
        make.trailing.equalToSuperview().inset(0)
        make.centerY.equalToSuperview()
        make.size.equalTo(CGSize(width: 19, height: 19))
      }
    }

  func hideMoveButton(isHidden: Bool) {
    moveButton.isHidden = isHidden
  }
  func setupText(text: String) {
    titleLabel.text = text
  }
  func setupButtonTag(itemNumber: Int) {
    moveButton.tag = itemNumber
  }
}

extension SectionHeader {
  @objc func tapButtonInHeader(_ sender: UIButton) {
    delegate?.didPressButtonInHeader(sender.tag)
  }
}

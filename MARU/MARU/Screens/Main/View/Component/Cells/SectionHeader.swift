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
  // MARK: - Library Cell에서 쓰일거임.

  let plusButton = UIButton().then {
    $0.setImage(UIImage(systemName: "plus")?
                  .withTintColor(.black, renderingMode: .alwaysOriginal)
                  .withConfiguration(UIImage.SymbolConfiguration(weight: .bold)),
                for: .normal)
    $0.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
  }
  weak var delegate: ButtonDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
    plusButton.isHidden = true
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
}
extension SectionHeader {
    func configure() {
      add(titleLabel)
      add(moveButton)
      add(plusButton)

      titleLabel.snp.makeConstraints { make in
        make.leading.equalToSuperview()
        make.centerY.equalToSuperview()
      }
      moveButton.snp.makeConstraints { make in
        make.leading.equalTo(titleLabel.snp.trailing).inset(-5)
        make.centerY.equalToSuperview()
        make.size.equalTo(CGSize(width: 19, height: 19))
      }
      plusButton.snp.makeConstraints { make in
        make.trailing.equalToSuperview().inset(0)
        make.centerY.equalToSuperview()
        make.size.equalTo(CGSize(width: 19, height: 19))
      }

    }
  func hideMoveButton(isHidden: Bool) {
    moveButton.isHidden = isHidden
  }
  func hidePlusButton(isHidden: Bool = true) {
    plusButton.isHidden = isHidden
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

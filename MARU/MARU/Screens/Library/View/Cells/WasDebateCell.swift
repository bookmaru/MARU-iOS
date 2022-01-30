//
//  wasDebateCell.swift
//  MARU
//
//  Created by psychehose on 2021/06/29.
//

import UIKit
import SnapKit

final class WasDebateCell: UICollectionViewCell {
  private let shadowView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 5
    return view
  }()

  private let bookImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .clear
    imageView.image = Image.testImage
    return imageView
  }()

  private let bookTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "test1"
    label.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.semibold)
    label.textAlignment = .left
    return label
  }()

  private let bookAuthorLabel: UILabel = {
    let label = UILabel()
    label.text = "test2"
    label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.light)
    label.textAlignment = .left
    return label
  }()
  private let evaluateButton: UIButton = {
    let button = UIButton()
    button.setTitle("방장 평가하기", for: .normal)
    button.backgroundColor = .white
    button.titleLabel?.font = .systemFont(ofSize: 9, weight: .medium)
    button.setTitleColor(.carolinaBlue, for: .normal)
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.carolinaBlue.cgColor
    button.layer.cornerRadius = 11
    button.contentEdgeInsets = UIEdgeInsets(top: 6,
                                            left: 9,
                                            bottom: 5,
                                            right: 9)
    button.isEnabled = true
    button.isUserInteractionEnabled = true
    return button
  }()

  weak var buttonDelegate: ButtonDelegate?
  // MARK: - RX로 교체할 수 있지 않을까?

  var libraryBook: LibraryModel? {
    didSet {
      bookTitleLabel.text = libraryBook?.bookTitle
      bookAuthorLabel.text = libraryBook?.bookAuthor
    }
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureHierarchy()
    applyShadow()
    addTarget()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func addTarget() {
    evaluateButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
  }

  @objc func didTapButton(_ sender: UIButton) {
    buttonDelegate?.didPressButtonInHeader(sender.tag)
  }

  func setupButtonTag(itemNumber: Int) {
    evaluateButton.tag = itemNumber
  }

  private func configureHierarchy() {
    contentView.add(shadowView)
    shadowView.adds([
      bookImageView,
      bookTitleLabel,
      bookAuthorLabel,
      evaluateButton
    ])

    shadowView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top).inset(1)
      make.bottom.equalTo(contentView.snp.bottom).inset(1)
      make.leading.equalTo(contentView.snp.leading).inset(1)
      make.trailing.equalTo(contentView.snp.trailing).inset(1)
    }
    bookImageView.snp.makeConstraints { ( make ) in
      make.top.equalTo(shadowView.snp.top).inset(0)
      make.leading.equalTo(shadowView.snp.leading).inset(0)
      make.bottom.equalTo(shadowView.snp.bottom).inset(0)
      make.width.equalTo(96)
    }
    bookTitleLabel.snp.makeConstraints { ( make ) in
      make.top.equalTo(shadowView.snp.top).inset(10)
      make.leading.equalTo(bookImageView.snp.trailing).inset(-10)
      make.height.equalTo(13)
    }
    bookAuthorLabel.snp.makeConstraints { ( make ) in
      make.top.equalTo(bookTitleLabel.snp.bottom).inset(-3)
      make.leading.equalTo(bookImageView.snp.trailing).inset(-10)
      make.height.equalTo(12)
    }
    evaluateButton.snp.makeConstraints { (make) in
      make.bottom.equalTo(shadowView.snp.bottom).inset(12)
      make.trailing.equalTo(shadowView.snp.trailing).inset(11)
    }
  }

  private func applyShadow() {
    shadowView.applyShadow(color: .black,
                           alpha: 0.28,
                           shadowX: 0,
                           shadowY: 0,
                           blur: 15/2)
  }
}

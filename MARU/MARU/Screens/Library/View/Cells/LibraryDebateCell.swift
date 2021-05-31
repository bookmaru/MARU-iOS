//
//  LibraryCell.swift
//  MARU
//
//  Created by psychehose on 2021/05/31.
//

import UIKit

final class LibraryDebateCell: UICollectionViewCell {

  private let bookImageView = UIImageView().then {
    $0.backgroundColor = .gray
    $0.layer.cornerRadius = 5
  }

  // MARK: - Override Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    applyLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func applyLayout() {
    contentView.add(bookImageView)

    bookImageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
}

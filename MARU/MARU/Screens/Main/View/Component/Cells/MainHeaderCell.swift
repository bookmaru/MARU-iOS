//
//  MainHeaderView.swift
//  MARU
//
//  Created by psychehose on 2021/05/21.
//

import UIKit

final class MainHeaderCell: UICollectionViewCell {
  private let backImageView = UIImageView().then {
    $0.image = Image.picture
  }
  private let backImageViewScrimView = UIView().then {
      $0.backgroundColor = UIColor.blackTwo
      $0.alpha = 0.5
  }
  private let bookLogoImageView = UIImageView().then {
    $0.image = Image.mainIcBook
  }
  private let commentLabel = UILabel().then {
      $0.numberOfLines = 2
      $0.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
      $0.textColor = .white
      $0.text = "사람들과 함께\n책장을 넘겨보세요."
  }
  lazy var searchBar = MaruSearchView(width: screenSize.width * 0.915,
                                      height: 36)
  private let screenSize = UIScreen.main.bounds.size

  override init(frame: CGRect) {
    super.init(frame: frame)
    applyLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func applyLayout() {
    contentView.add(backImageView)
    backImageView.adds([
      backImageViewScrimView,
      bookLogoImageView,
      commentLabel
    ])
    add(searchBar)

    backImageView.snp.makeConstraints { make in
      make.top.equalTo(contentView.snp.top)
      make.leading.equalTo(self.snp.leading)
      make.trailing.equalTo(self.snp.trailing)
      make.height.equalTo(screenSize.height * 0.313)
    }
    backImageViewScrimView.snp.makeConstraints { (make) in
      make.edges.equalTo(backImageView.snp.edges)
    }
    bookLogoImageView.snp.makeConstraints { (make) in
      make.top.equalTo(backImageView.snp.top).inset(screenSize.height * 0.138)
      make.height.equalTo(28)
      make.width.equalTo(29)
      make.leading.equalTo(backImageView.snp.leading).inset(20)
    }
    commentLabel.snp.makeConstraints { (make) in
      make.top.equalTo(bookLogoImageView.snp.bottom).inset(-8)
      make.leading.equalTo(backImageView.snp.leading).inset(20)
    }
    searchBar.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().inset(2)
      make.leading.equalToSuperview().inset(20)
    }
  }

}

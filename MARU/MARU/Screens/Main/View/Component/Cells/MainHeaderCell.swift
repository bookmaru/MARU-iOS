//
//  MainHeaderView.swift
//  MARU
//
//  Created by psychehose on 2021/05/21.
//

import UIKit

final class MainHeaderCell: UICollectionViewCell {
  static let identifier = "MainHeaderView"

  let backImageView = UIImageView().then {
    $0.image = Image.picture
  }
  let backImageViewScrim = UIView().then {
      $0.backgroundColor = UIColor.blackTwo
      $0.alpha = 0.5
  }
  let bookLogoImageView = UIImageView().then {
    $0.image = Image.mainIcBook
  }
  let commentLabel = UILabel().then {
      $0.numberOfLines = 2
      $0.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
      $0.textColor = .white
      $0.text = "사람들과 함께\n책장을 넘겨보세요."
  }
  lazy var searchBar = MaruSearchView(width: screenSize.width * 0.915,
                                      height: 38)
  let mypageButton = UIButton().then {
    $0.setImage(Image.mainBtnMy, for: .normal)
  }

  let screenSize = UIScreen.main.bounds.size

  override init(frame: CGRect) {
    super.init(frame: frame)
    applyLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func applyLayout() {
    contentView.add(backImageView)
    backImageView.add(backImageViewScrim)
    backImageView.adds([mypageButton,
                        bookLogoImageView,
                        commentLabel
                        ])
    add(searchBar)

    backImageView.snp.makeConstraints { make in
      make.top.equalTo(contentView.snp.top)
      make.leading.equalTo(self.snp.leading)
      make.trailing.equalTo(self.snp.trailing)
      make.height.equalTo(270)
    }
    backImageViewScrim.snp.makeConstraints { (make) in
      make.edges.equalTo(backImageView.snp.edges)
    }
    mypageButton.snp.makeConstraints { (make) in
      make.top.equalTo(backImageView.snp.top).inset(56)
      make.trailing.equalTo(backImageView.snp.trailing).inset(12)
      make.height.equalTo(20)
      make.width.equalTo(32)
    }
    bookLogoImageView.snp.makeConstraints { (make) in
      make.top.equalTo(backImageView.snp.top).inset(124)
      make.height.equalTo(28)
      make.width.equalTo(29)
      make.leading.equalTo(backImageView.snp.leading).inset(18)
    }
    commentLabel.snp.makeConstraints { (make) in
        make.top.equalTo(bookLogoImageView.snp.bottom).inset(-14)
        make.bottom.equalTo(backImageView.snp.bottom).inset(34)
        make.leading.equalTo(backImageView.snp.leading).inset(16)
        make.trailing.equalTo(backImageView.snp.trailing)

    }
    searchBar.snp.makeConstraints { (make) in
      make.top.equalTo(commentLabel.snp.bottom).inset(-15)
      make.leading.equalTo(self.snp.leading).inset(16)
    }
  }

}

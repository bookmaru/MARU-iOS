//
//  BookFavoritesViewController.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/12.
//

import UIKit
import RxSwift
import RxCocoa

final class BookFavoritesViewController: BaseViewController {
  let emptyView = UIView().then {
    $0.backgroundColor = .white
  }
  let bookImage = UIImageView().then {
    $0.image = Image.autoStories
  }
  let emptyLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = .subText
    $0.textAlignment = .center
    $0.text = """
    모임하고 싶은 책이 아직 없어요.
    + 버튼을 눌러 서재를 채워주세요!
    """
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    render()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: false)
    navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
    navigationController?.navigationBar.barTintColor = .white
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(didTapAddBookButton))
    navigationItem.rightBarButtonItem?.tintColor = .black
    tabBarController?.tabBar.isHidden = true
  }
}

extension BookFavoritesViewController {
  func render() {
    view.add(emptyView) { make in
      make.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    emptyView.add(bookImage) { make in
      make.snp.makeConstraints {
        $0.size.equalTo(16)
        $0.centerX.equalTo(self.emptyView)
        $0.centerY.equalTo(self.emptyView)
      }
    }
    emptyView.add(emptyLabel) { make in
      make.snp.makeConstraints {
        $0.top.equalTo(self.bookImage.snp.bottom).offset(4)
        $0.centerX.equalTo(self.emptyView)
      }
    }
  }
  @objc func didTapAddBookButton() {
    let viewController = SearchBookViewController()
    self.navigationController?.pushViewController(viewController, animated: false)
  }
}

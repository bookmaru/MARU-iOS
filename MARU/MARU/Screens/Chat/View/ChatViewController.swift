//
//  ChatViewController.swift
//  MARU
//
//  Created by 오준현 on 2021/04/20.
//

import UIKit

final class ChatViewController: BaseViewController {

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ChatCollectionViewCell.self,
                            forCellWithReuseIdentifier: ChatCollectionViewCell.reuseIdentifier)
    collectionView.backgroundColor = .white
    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    tabBarController?.tabBar.isHidden = true
  }

}

extension ChatViewController {
  private func layout() {
    view.add(collectionView) {
      $0.snp.makeConstraints {
        $0.edges.equalTo(self.view.safeAreaLayoutGuide)
      }
      $0.delegate = self
      $0.dataSource = self
    }
  }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 100, height: 100)
  }
}

extension ChatViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: ChatCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

    return cell
  }
}

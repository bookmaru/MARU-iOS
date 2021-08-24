//
//  UICollectionView+.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

import UIKit

extension UICollectionReusableView: ReusableView { }

extension UICollectionView {
  func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier,
                                         for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
    }
    return cell
  }

  func dequeueHeaderView<T: UICollectionReusableView>(forIndexPath indexPath: IndexPath) -> T {
    guard let view = dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: T.reuseIdentifier,
      for: indexPath
    ) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
    }
    return view
  }

  func dequeueFooterView<T: UICollectionReusableView>(forIndexPath indexPath: IndexPath) -> T {
    guard let view = dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: T.reuseIdentifier,
      for: indexPath
    ) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
    }
    return view
  }

  func restore() {
    self.backgroundView = nil
  }

  func register<T>(
    cell: T.Type,
    forCellWithReuseIdentifier reuseIdentifier: String = T.reuseIdentifier
  ) where T: UICollectionViewCell {
      register(cell, forCellWithReuseIdentifier: reuseIdentifier)
  }
  func scrollToSupplementaryView(ofKind kind: String,
                                 at indexPath: IndexPath,
                                 at scrollPosition: UICollectionView.ScrollPosition,
                                 animated: Bool) {
    self.layoutIfNeeded()
    if let layoutAttributes = self.layoutAttributesForSupplementaryElement(ofKind: kind, at: indexPath) {
      let viewOrigin = CGPoint(x: layoutAttributes.frame.origin.x, y: layoutAttributes.frame.origin.y)
      var resultOffset: CGPoint = self.contentOffset
      let layoutAttributeSize = layoutAttributes.frame.size

      switch scrollPosition {
      case UICollectionView.ScrollPosition.top:
        resultOffset.y = viewOrigin.y - self.contentInset.top

      case UICollectionView.ScrollPosition.left:
        resultOffset.x = viewOrigin.x - self.contentInset.left

      case UICollectionView.ScrollPosition.right:
        resultOffset.x
          = (viewOrigin.x - self.contentInset.left) - (self.frame.size.width - layoutAttributeSize.width)

      case UICollectionView.ScrollPosition.bottom:
        resultOffset.y
          = (viewOrigin.y - self.contentInset.top) - (self.frame.size.height - layoutAttributeSize.height)

      case UICollectionView.ScrollPosition.centeredVertically:
        resultOffset.y
          = (viewOrigin.y - self.contentInset.top) - (self.frame.size.height / 2 - layoutAttributeSize.height / 2)

      case UICollectionView.ScrollPosition.centeredHorizontally:
        resultOffset.x
          = (viewOrigin.x - self.contentInset.left) - (self.frame.size.width / 2 - layoutAttributeSize.width / 2)
      default:
        break
      }
      self.scrollRectToVisible(CGRect(origin: resultOffset, size: self.frame.size), animated: animated)
    }
  }
}

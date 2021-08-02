//
//  UITableView+.swift
//  MARU
//
//  Created by 이윤진 on 2021/07/19.
//

import UIKit

extension UITableViewCell: ReusableView { }

extension UITableView {
  func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier,
                                         for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
    }
    return cell
  }
  func restore() {
    self.backgroundView = nil
  }
}

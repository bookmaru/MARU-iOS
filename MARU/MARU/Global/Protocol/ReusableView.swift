//
//  ReusableView.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

import UIKit

protocol ReusableView: AnyObject {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

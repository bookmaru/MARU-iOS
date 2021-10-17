//
//  RxViewController+.swift
//  MARU
//
//  Created by 오준현 on 2021/10/11.
//

import RxSwift

extension RxSwift.Reactive where Base: UIViewController {
  var viewDidLoad: Observable<Void> {
    return methodInvoked(#selector(UIViewController.viewDidLoad))
      .map { _ in }
  }

  var viewWillAppear: Observable<Void> {
    return methodInvoked(#selector(UIViewController.viewWillAppear))
       .map { _ in }
  }
}

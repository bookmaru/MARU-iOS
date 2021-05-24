//  MainViewModel.swift
//  MARU
//
//  Created by psychehose on 2021/05/08.

import Foundation

import RxCocoa
import RxSwift

final class MainViewModel: ViewModelType {
  let disposeBag = DisposeBag()

  struct Input {
  }

  struct Output {
  }

  func transform(input: Input) -> Output {
    return Output()
  }
}

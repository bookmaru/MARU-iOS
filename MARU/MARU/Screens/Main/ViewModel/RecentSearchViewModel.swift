//
//  RecentSearchViewModel.swift
//  MARU
//
//  Created by psychehose on 2021/07/18.
//

import Foundation

import RxSwift
import RxCocoa

final class RecentSearchViewModel: ViewModelType {

  struct Input {
    let viewTrigger: Driver<Void>
    let tapCancleButton: Driver<Void>
    let tapDeleteButton: Driver<Void>
    let writeText: Driver<String>
    let tapSearchButton: Driver<Void>
  }

  struct Output {
//    let fetching: Driver<Bool>
    let cancle: Driver<Bool>
//    let selectedPost: Driver<Post>
//    let delete: Driver<Bool>
//    let error: Driver<Error>
    let keyword: Driver<String>
  }
  func transform(input: Input) -> Output {
    let cancle = input.tapCancleButton
      .map { () in
        return true
      }
      .asDriver()

    let keyword = input.tapSearchButton.withLatestFrom(input.writeText)
      .map { $0 }
      .asDriver()

    return Output(cancle: cancle, keyword: keyword)
  }
}

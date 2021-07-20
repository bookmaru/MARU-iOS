//
//  RecentSearchViewModel.swift
//  MARU
//
//  Created by psychehose on 2021/07/18.
//

import Foundation
import OrderedCollections

import RealmSwift
import RxSwift
import RxCocoa

final class RecentSearchViewModel: ViewModelType {
  private var savedKeywordList: [String] = []

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
    let delete: Driver<Void>
//    let error: Driver<Error>
    let keyword: Driver<String>
    let keywordList: Driver<[String]>
  }
  func transform(input: Input) -> Output {
    let cancle = input.tapCancleButton
      .map { () in
        return true
      }
      .asDriver()

    let delete = input.tapDeleteButton
      .do(onNext: {
        self.savedKeywordList.removeAll()
      })
      .asDriver()

    let keyword = input.tapSearchButton.withLatestFrom(input.writeText)
      .distinctUntilChanged()
//      .debounce(RxTimeInterval.microseconds(5))
      .do(onNext: { [self] keyword in
        var orderSet = OrderedSet(savedKeywordList).subtracting([keyword])
        orderSet.insert(keyword, at: 0)
        savedKeywordList = Array(orderSet)
      })
      .asDriver()

    let keywordList = Driver.merge(input.tapDeleteButton,
                                   input.tapSearchButton)
      .map { _ in
        return self.savedKeywordList
      }
      .asDriver()
    return Output(cancle: cancle,
                  delete: delete,
                  keyword: keyword,
                  keywordList: keywordList)
  }
}

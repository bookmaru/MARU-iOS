//
//  RecentSearchViewModel.swift
//  MARU
//
//  Created by psychehose on 2021/07/18.
//

import Foundation

import RealmSwift
import RxSwift
import RxCocoa

final class RecentSearchViewModel: ViewModelType {
  private var realm: Realm!

  struct Input {
    let viewTrigger: Driver<Void>
    let tapCancelButton: Driver<Void>
    let tapDeleteButton: Driver<Void>
    let writeText: Driver<String>
    let tapSearchButton: Driver<Void>
    let tapListCell: Driver<String>
  }

  struct Output {
    let load: Driver<Results<RecentSearchKeyword>>
    let cancel: Driver<Bool>
    let delete: Driver<Void>
    let keyword: Driver<String>
  }

  init() {
    do {
      self.realm = try Realm()
    } catch let err as NSError {
      print(err)
    }
  }

  func transform(input: Input) -> Output {

    let load = Driver.merge(input.viewTrigger)
      .map { [weak self] _ -> Results<RecentSearchKeyword> in
        return self!.realm.objects(RecentSearchKeyword.self)
          .sorted(byKeyPath: "created", ascending: false)
      }
      .asDriver()

    let cancel = input.tapCancelButton
      .map { _ in
        return true
      }
      .asDriver()

    let delete = input.tapDeleteButton
      .do(onNext: { [self] in
        do {
          try realm.write {
            realm.deleteAll()
          }
        } catch let err as NSError {
          print(err)
        }
      })
      .asDriver()

    let keyword = Driver.merge(
      input.tapSearchButton.withLatestFrom(input.writeText),
      input.tapListCell
    )
    .debounce(RxTimeInterval.microseconds(5))
    .do(onNext: { [self] keyword in
      let keywordObject = RecentSearchKeyword()
      keywordObject.keyword = keyword
      do {
        try self.realm.write {
          realm.add(keywordObject, update: .modified)
        }
      } catch let err as NSError {
        print(err)
      }
    })
    .asDriver()

    return Output(load: load,
                  cancel: cancel,
                  delete: delete,
                  keyword: keyword)
  }
}

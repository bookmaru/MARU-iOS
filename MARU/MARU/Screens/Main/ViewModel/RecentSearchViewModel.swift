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
  var realm: Realm!

  struct Input {
    let viewTrigger: Driver<Void>
    let tapCancleButton: Driver<Void>
    let tapDeleteButton: Driver<Void>
    let writeText: Driver<String>
    let tapSearchButton: Driver<Void>
  }

  struct Output {
    let load: Driver<Results<RecentSearchKeyword>>
    let cancle: Driver<Bool>
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

    let load = Driver.merge(input.viewTrigger,
                            input.tapDeleteButton,
                            input.tapSearchButton) // 확인으로 tapSearch 넣어놓은 것.
      .map { [self] _  ->  Results<RecentSearchKeyword> in
        return realm.objects(RecentSearchKeyword.self).sorted(byKeyPath: "created",
                                                              ascending: false)
      }
      .asDriver()

    let cancle = input.tapCancleButton
      .map { () in
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

    let keyword = input.tapSearchButton.withLatestFrom(input.writeText)
      .distinctUntilChanged()
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
                  cancle: cancle,
                  delete: delete,
                  keyword: keyword)
  }
}

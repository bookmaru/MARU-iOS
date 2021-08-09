//
//  MoreNewViewModel.swift
//  MARU
//
//  Created by psychehose on 2021/08/10.
//

import Foundation

import RxSwift
import RxCocoa

final class MoreNewViewModel: ViewModelType {

  struct Input {
    let viewTrigger: Observable<Void>
    let tapCategoryButton: Observable<(Void, String)>
    let didScrollBottom: Observable<(Bool, Int?)>
  }
  struct Output {
    let load: Driver<[MeetingModel]>
    let filter: Driver<[MeetingModel]>
    let fetchMore: Driver<[MeetingModel]>
    let errorMessage: Observable<Error>
  }

  func transform(input: Input) -> Output {
    let allCategory = BehaviorRelay<[MeetingModel]>(value: [])
    let errorMessage = PublishSubject<Error>()
    var filterString = "전체"

    let load = input.viewTrigger
      .take(1)
      .flatMap(NetworkService.shared.home.getNewAllCategory)
      .map { response -> BaseReponseType<GroupsByCategories> in

        guard 200 ..< 300 ~= response.status else {
          errorMessage.onNext(
            MaruError.serverError(response.status)
          )
          return response
        }
        return response
      }
      .map {$0.data?.groupsByCategory }
      .map { groupsByCategory -> [GroupsByCategory] in
        guard let groupsByCategory = groupsByCategory else { return [] }
        return groupsByCategory
      }
      .map { $0.map { groupsByCategory in
        groupsByCategory.groups.map { MeetingModel($0, groupsByCategory.category) }}
      }
      .map { $0.flatMap { $0 }}
      .do(onNext: {
        allCategory.accept(allCategory.value + $0)
      })
      .asDriver(onErrorJustReturn: [])

    let filter = input.tapCategoryButton
      .map { filter -> String in
        filterString = filter.1
        return filterString
      }
      .distinctUntilChanged()
      .withLatestFrom(allCategory)
      .map { meetingModels -> [MeetingModel] in
        if filterString != "전체" {
          return meetingModels.filter { $0.category == filterString }
        } else { return meetingModels }
      }
      .map { $0 }
      .asDriver(onErrorJustReturn: [])

    let fetchMore = input.didScrollBottom
      .filter { $0.0 }
      .debounce(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
      .flatMap { NetworkService.shared.home.getNewCategory(category: filterString, currentGroupCount: ($0.1!))}
      .map { response -> BaseReponseType<Groups> in
        guard 200 ..< 300 ~= response.status else {
          errorMessage.onNext(
            MaruError.serverError(response.status)
          )
          return response
        }
        return response
      }
      .map { $0.data?.groups.map { MeetingModel($0, filterString)} }
      .map { meetingModel -> [MeetingModel] in
        guard let meetingModel = meetingModel else { return [] }
        return meetingModel
      }
      .do(onNext: {
        var alreadyThere = Set<MeetingModel>()
        let uniqueMeetingModels = $0.compactMap { (meetingModel) -> MeetingModel? in
            guard !alreadyThere.contains(meetingModel) else { return nil }
            alreadyThere.insert(meetingModel)
            return meetingModel
        }
        allCategory.accept(allCategory.value + uniqueMeetingModels)
      })
      .withLatestFrom(allCategory)
      .map { $0.filter { $0.category == filterString } }
      .asDriver(onErrorJustReturn: [])

    return Output(load: load,
                  filter: filter,
                  fetchMore: fetchMore,
                  errorMessage: errorMessage)
  }
}

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
    let tapCategoryButton: Observable<String>
    let didScrollBottom: Observable<(Bool, Int?)>
  }

  struct Output {
    let load: Driver<[MeetingModel]>
    let tapCategoryButton: Driver<[MeetingModel]>
    let fetchMore: Driver<[MeetingModel]>
    let errorMessage: Observable<Error>
  }

  func transform(input: Input) -> Output {
    let errorMessage = PublishSubject<Error>()
    var categoryString: String = ""
    var pageIndex: Int = 1

    let load = input.viewTrigger
      .take(1)
      .flatMap { NetworkService.shared.home.getNew(page: 1) }
      .map { response -> BaseReponseType<Groups> in
        guard 200 ..< 300 ~= response.status else {
          errorMessage.onNext(
            MaruError.serverError(response.status)
          )
          return response
        }
        return response
      }
      .map { $0.data?.groups.map { MeetingModel($0)} }
      .map { meetingModel -> [MeetingModel] in
        guard let meetingModel = meetingModel else { return [] }
        return meetingModel
      }
      .asDriver(onErrorJustReturn: [])

    let tapCategoryButton = input.tapCategoryButton
      .debounce(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
      .distinctUntilChanged()
      .flatMap { category -> Observable<BaseReponseType<Groups>> in
        categoryString = category
        if category == "전체" {
          pageIndex = 1
          return NetworkService.shared.home.getNew(page: 1)
        }
        return NetworkService.shared.home.getNewCategory(category: category, currentGroupCount: 1)
      }
      .map { response -> BaseReponseType<Groups> in
        guard 200 ..< 300 ~= response.status else {
          errorMessage.onNext(
            MaruError.serverError(response.status)
          )
          return response
        }
        return response
      }
      .do(onError: { err in errorMessage.onNext(err) })
      .map { $0.data?.groups.map { MeetingModel($0)} }
      .map { meetingModel -> [MeetingModel] in
        guard let meetingModel = meetingModel else { return [] }
        return meetingModel
      }
      .asDriver(onErrorJustReturn: [])

    let fetchMore = input.didScrollBottom
      .filter { $0.0 }
      .map { $0.1 }
      .debounce(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
      .flatMap { categoryGroupCount -> Observable<BaseReponseType<Groups>> in
        if categoryString == "전체" {
          pageIndex += 1
          return NetworkService.shared.home.getNew(page: pageIndex)
        }
        return NetworkService.shared.home.getNewCategory(
          category: categoryString,
          currentGroupCount: categoryGroupCount ?? 0
        )
      }
      .map { response -> BaseReponseType<Groups> in
        guard 200 ..< 300 ~= response.status else {
          errorMessage.onNext(
            MaruError.serverError(response.status)
          )
          return response
        }
        return response
      }
      .map { $0.data?.groups.map { MeetingModel($0)} }
      .map { meetingModel -> [MeetingModel] in
        guard let meetingModel = meetingModel else { return [] }
        return meetingModel
      }
      .asDriver(onErrorJustReturn: [])

    return Output(
      load: load,
      tapCategoryButton: tapCategoryButton,
      fetchMore: fetchMore,
      errorMessage: errorMessage
    )
  }
}

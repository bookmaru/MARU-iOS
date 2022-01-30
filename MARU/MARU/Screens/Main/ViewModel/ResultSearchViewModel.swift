//
//  ResultSearchViewModel.swift
//  MARU
//
//  Created by psychehose on 2021/07/28.
//

import Foundation

import RxSwift
import RxCocoa

final class ResultSearchViewModel: ViewModelType {
  struct Input {
    let viewTrigger: Observable<Void>
    let keyword: String?
    let tapCancelButton: Driver<Void>
    let tapTextField: Driver<Void>
  }

  struct Output {
    let result: Driver<[MeetingModel]>
    let cancel: Driver<Void>
    let reSearch: Driver<Void>
    let canMakeGroup: Driver<Bool>
    let errorMessage: Observable<Error>
  }

  func transform(input: Input) -> Output {
    let errorMessage = PublishSubject<Error>()
    let canMakeGroupPublishSubject = PublishSubject<Void>()

    let result = input.viewTrigger
      .flatMap { NetworkService.shared.search.search(queryString: input.keyword ?? "") }
      .map { response -> BaseResponseType<Groups> in

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
      .do { meetingModels in
        if meetingModels.isEmpty {
          canMakeGroupPublishSubject.onNext(())
        }
      }
      .asDriver(onErrorJustReturn: [])

    let cancel = input.tapCancelButton
      .asDriver()

    let reSearch = input.tapTextField
      .asDriver()

    let canMakeGroup = canMakeGroupPublishSubject
      .flatMap(NetworkService.shared.auth.myGroup)
      .map { $0.data?.groups.count ?? -1 }
      .map { count in
        if count >= 0 && count < 2 {
          return  true
        }
        return false
      }
      .asDriver(onErrorJustReturn: false)

    return Output(
      result: result,
      cancel: cancel,
      reSearch: reSearch,
      canMakeGroup: canMakeGroup,
      errorMessage: errorMessage
    )
  }
}

//  MainViewModel.swift
//  MARU
//
//  Created by psychehose on 2021/05/08.

import Foundation

import RxCocoa
import RxSwift

final class MainViewModel: ViewModelType {

  struct Input {
    let fetch: Observable<Void>
  }

  struct Output {
    let allPopularMeetings: Observable<[BookModel]>
    let allNewMeetings: Observable<[MeetingModel]>
    let errorMessage: Observable<Error>
  }

  func transform(input: Input) -> Output {
    let errorMessage = PublishSubject<Error>()

    let allPopularMeetings = input.fetch
      .flatMap(NetworkService.shared.home.getPopular)
      .map { response -> BaseReponseType<Books> in
        guard 200 ..< 300 ~= response.status else {
          errorMessage.onNext(
            MaruError.serverError(response.status)
          )
          return response
        }
        return response
      }
      .map { $0.data?.books.map { BookModel($0)} }
      .map { bookModel -> [BookModel] in
        guard let bookModel = bookModel else { return [] }
        return bookModel
      }
      .catchErrorJustReturn([])

    let allNewMeetings = input.fetch
      .flatMap(NetworkService.shared.home.getNew)
      .map { response -> BaseReponseType<Groups> in
        guard 200 ..< 300 ~= response.status else {
          throw NSError.init(
            domain: "Detect Error in Fetching New meetings",
            code: -1,
            userInfo: nil
          )
        }
        return response
      }
      .do(onError: { err in errorMessage.onNext(err) })
      .map { $0.data?.groups.map { MeetingModel($0)} }
      .map { meetingModel -> [MeetingModel] in
        guard let meetingModel = meetingModel else { return [] }
        return meetingModel
      }
      .catchErrorJustReturn([])

    return Output(
      allPopularMeetings: allPopularMeetings,
      allNewMeetings: allNewMeetings,
      errorMessage: errorMessage
    )
  }
}

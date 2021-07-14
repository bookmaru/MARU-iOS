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
    let fetchPopularMeeting: Observable<Void>
  }
  struct Output {
    let allPopularMeetings: Observable<[MainModel]>
//    let errorMessage: Observable<NSError>
  }

  func transform(input: Input) -> Output {
    let abc  = input.fetchPopularMeeting
      .flatMap(NetworkService.shared.home.getPopular)
      .map {$0.data?.books.map { MainModel($0)}}
      .map {$0!}
    return Output(allPopularMeetings: abc)
  }
}

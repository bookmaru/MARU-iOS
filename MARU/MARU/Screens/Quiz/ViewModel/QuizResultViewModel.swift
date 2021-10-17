//
//  QuizResultViewModel.swift
//  MARU
//
//  Created by psychehose on 2021/08/24.
//

import RxSwift
import RxCocoa

final class QuizResultViewModel: ViewModelType {
  struct Input {
    let viewTrigger: Observable<Void>
    let resultValue: Observable<(Int, String)>
    let tapOk: Observable<Void>
  }
  struct Output {
    let response: Driver<Bool>
    let goMain: Driver<Void>
  }
  func transform(input: Input) -> Output {
    let response = input.viewTrigger
      .withLatestFrom(input.resultValue)
      .flatMap { NetworkService.shared.quiz.checkQuiz(groupID: $0.0, isEnter: $0.1) }
      .map { $0.data?.checkQuiz }
      .map { checkQuiz -> Bool in
        guard let checkQuiz = checkQuiz else { return false }
        return checkQuiz
      }
      .asDriver(onErrorJustReturn: false)
    let goMain = input.tapOk
      .asDriver(onErrorJustReturn: ())
    return Output(response: response, goMain: goMain)
  }
}

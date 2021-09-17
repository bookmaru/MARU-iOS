//
//  QuizViewModel.swift
//  MARU
//
//  Created by psychehose on 2021/04/10.
//
import Foundation

import RxSwift
import RxCocoa

final class QuizViewModel: ViewModelType {
  struct ContentAndIndex {
    let content: String
    let index: Int
    let isPass: Bool
  }

  struct Input {
    let viewTrigger: Observable<(Void, Int)>
    let tapButton: Driver<(Bool, String)>
    let timeout: Driver<Void>
  }

  struct Output {
    let load: Driver<[String]>
    let judge: Driver<Void>
    let timeout: Driver<Void>
    let contentAndIndex: Driver<ContentAndIndex>
    let checkMarker: Driver<(Bool, Int)>
    let isPass: Driver<Bool>
  }

  func transform(input: Input) -> Output {
    var content: [String] = []
    var answers: [String] = []

    let checkMarker = PublishSubject<(Bool, Int)>()
    let contentAndIndex = BehaviorRelay<ContentAndIndex>(value: ContentAndIndex(content: "", index: 0, isPass: false))
//    let contentAndIndex = BehaviorRelay<(String, Int, Bool)>(value: ("", 0, false))
    var passVar = true
    let isPass = PublishSubject<Bool>()
    var results: [Bool] = []

    let load = input.viewTrigger
      .flatMap { NetworkService.shared.quiz.getQuiz(groupID: $0.1) }
      .map { $0.data?.quizzes }
      .map { quizModel -> [Quiz] in
        guard let quizModel = quizModel else { return [] }
        return quizModel
      }
      .do(onNext: {
        answers = $0.map { $0.answer }
        content = $0.map { $0.content }
      })
      .do(onNext: { _ in
        contentAndIndex.accept(ContentAndIndex(content: content[0], index: 0, isPass: true))
      })
      .map { $0.map { $0.content } }
      .asDriver(onErrorJustReturn: [])

    let judge = input.tapButton
      .filter { $0.0 }
      .do(onNext: { _, button in
        results.append(answers[contentAndIndex.value.index] == button)
      })
      .do(onNext: { _ in
        checkMarker.onNext((results.last ?? false, results.count - 1 ))
      })
      .do(onNext: { _ in
        if results.count >= 3 {
          if results.filter({ $0 == true }).count >= 3 {
            isPass.onNext(true)
            passVar = false
          }
          if results.filter({ $0 == false }).count >= 3 {
            isPass.onNext(false)
            passVar = false
          }
        }
      })
      .delay(RxTimeInterval.milliseconds(500))
      .do(onNext: { _ in
        guard results.count < 5 else { return }
        contentAndIndex.accept(
          ContentAndIndex(content: content[results.count], index: results.count, isPass: passVar)
        )
      })
      .map { _ in }
      .asDriver()

    let timeout = input.timeout
      .do(onNext: { _ in
        results.append(false)
      })
      .do(onNext: { _ in
        checkMarker.onNext((results.last ?? false, results.count - 1 ))
      })
      .do(onNext: { _ in
        if results.count >= 3 {
          if results.filter({ $0 == true }).count >= 3 {
            isPass.onNext(true)
            passVar = false
          }
          if results.filter({ $0 == false }).count >= 3 {
            isPass.onNext(false)
            passVar = false
          }
        }
      })
      .delay(RxTimeInterval.milliseconds(500))
      .do(onNext: { _ in
        guard results.count < 5 else { return }
        contentAndIndex.accept(
          ContentAndIndex(content: content[results.count], index: results.count, isPass: passVar)
        )
      })
      .asDriver()

    return Output(
      load: load,
      judge: judge,
      timeout: timeout,
      contentAndIndex: contentAndIndex.asDriver(),
      checkMarker: checkMarker.asDriver(onErrorJustReturn: (false, 0)),
      isPass: isPass.asDriver(onErrorJustReturn: false)
    )
  }
}

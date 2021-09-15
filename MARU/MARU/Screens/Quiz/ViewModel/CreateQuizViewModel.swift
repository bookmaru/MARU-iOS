//
//  CreateQuizViewModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/16.
//

import Foundation

import RxSwift
import RxCocoa

final class CreateQuizViewModel: ViewModelType {
  struct Dependency {
    let bookModel: BookModel
  }
  struct Input {
    let viewTrigger: Observable<Void>
    let tapCancleButton: Observable<Void>
    let tapCompleteButton: Observable<Void>
    let description: Observable<String>
    let quizProblem: Observable<(String, Int)>
    let quizAnswer: Observable<(String, Int)>
  }
  struct Output {
    let description: Driver<Void>
    let quizProblem: Driver<Void>
    let quizAnswer: Driver<Void>
    let didTapCancle: Driver<Void>
    let didTapComplement: Driver<Void>
  }
  init(dependency: Dependency) {
    self.bookModel = dependency.bookModel
  }
  let bookModel: BookModel

  func transform(input: Input) -> Output {

    var quizzes = [String](repeating: "", count: 5)
    var answers = [String](repeating: "", count: 5)
    var description: String = ""

    let quizProblem = input.quizProblem
      .do(onNext: { quiz, number in
        quizzes[number] = quiz
      })
      .map { _ in () }
      .asDriver(onErrorJustReturn: ())

    let quizAnswer = input.quizAnswer
      .do(onNext: { answer, number in
        answers[number] = answer
      })
      .map { _ in () }
      .asDriver(onErrorJustReturn: ())

    let descript = input.description
      .do(onNext: {
        description = $0
      })
      .map { _ in () }
      .asDriver(onErrorJustReturn: ())

    let didTapCancle = input.tapCancleButton
      // MARK: Test용으로 일단 남겨놓을게요.
      .do(onNext: {
        debugPrint(self.bookModel)
        debugPrint(description)
        debugPrint(quizzes)
        debugPrint(answers)
      })
      .asDriver(onErrorJustReturn: ())

    let didTapComplement = input.tapCompleteButton
      .flatMap { NetworkService.shared.quiz.createQuiz(
        makeGroup: MakeGroup.init(
          book: self.bookModel,
          group: .init(isbn: self.bookModel.isbn, description: description),
          question: Question.init(answer: answers, quiz: quizzes)
        )
      )
      }
      // MARK: - 여기서 화면전환 -> GroupID
      .map { $0 }
      .map { _ in () }
      .asDriver(onErrorJustReturn: ())

    return Output(
      description: descript,
      quizProblem: quizProblem,
      quizAnswer: quizAnswer,
      didTapCancle: didTapCancle,
      didTapComplement: didTapComplement
    )
  }
}

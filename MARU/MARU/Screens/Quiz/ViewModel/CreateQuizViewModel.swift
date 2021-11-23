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
    let didTapComplement: Driver<Int>
    let tappableComplement: Driver<Bool>
    let errorMessage: Observable<Error>
  }
  init(dependency: Dependency) {
    self.bookModel = dependency.bookModel
  }
  let bookModel: BookModel

  func transform(input: Input) -> Output {

    var quizzes = [String](repeating: "", count: 5)
    var answers = [String](repeating: "", count: 5)
    var description: String = ""
    let tappableComplement = PublishSubject<Bool>()
    let errorMessage = PublishSubject<Error>()

    let quizProblem = input.quizProblem
      .do(onNext: { quiz, number in
        quizzes[number] = quiz
      })
      .do(onNext: { [weak self] _ in
        guard let self = self else { return }
        tappableComplement.onNext(
          self.checkComplement(description: description, quizzes: quizzes, answers: answers))
      })
      .map { _ in () }
      .asDriver(onErrorJustReturn: ())

    let quizAnswer = input.quizAnswer
      .do(onNext: { answer, number in
        answers[number] = answer
      })
      .do(onNext: { [weak self] _ in
        guard let self = self else { return }
        tappableComplement.onNext(
          self.checkComplement(description: description, quizzes: quizzes, answers: answers))
      })
      .map { _ in () }
      .asDriver(onErrorJustReturn: ())

    let descript = input.description
      .do(onNext: {
        description = $0
      })
      .do(onNext: { [weak self] _ in
        guard let self = self else { return }
        tappableComplement.onNext(
          self.checkComplement(description: description, quizzes: quizzes, answers: answers))
      })
      .map { _ in () }
      .asDriver(onErrorJustReturn: ())

    let didTapCancle = input.tapCancleButton
      .asDriver(onErrorJustReturn: ())

    let didTapComplement = input.tapCompleteButton
      .flatMap { NetworkService.shared.quiz.createQuiz(
        makeGroup: MakeGroup.init(
          book: MakeBook.init(
            isbn: (self.bookModel.isbn).string,
            title: self.bookModel.title,
            author: self.bookModel.author,
            imageUrl: self.bookModel.imageURL,
            category: self.bookModel.category
          ),
          group: .init(isbn: (self.bookModel.isbn).string, description: description),
          question: Question.init(answer: answers, quiz: quizzes)
        )
      )}
      .map { response -> BaseResponseType<ResultMakeGroup> in
        guard 200 ..< 300 ~= response.status else {
          errorMessage.onNext(
            MaruError.serverError(response.status)
          )
          return response
        }
        return response
      }
      .map { $0.data?.groupID ?? -1 }
      .map { $0 }
      .asDriver(onErrorJustReturn: -1)

    return Output(
      description: descript,
      quizProblem: quizProblem,
      quizAnswer: quizAnswer,
      didTapCancle: didTapCancle,
      didTapComplement: didTapComplement,
      tappableComplement: tappableComplement.asDriver(onErrorJustReturn: false),
      errorMessage: errorMessage
    )
  }
}
extension CreateQuizViewModel {
  func checkComplement(
    description: String,
    quizzes: [String],
    answers: [String]
  ) -> Bool {
    guard !description.isEmpty,
          quizzes.filter({ $0.isEmpty }).count == 0,
          answers.filter({ $0.isEmpty }).count == 0 else { return false }
    return true
  }
}

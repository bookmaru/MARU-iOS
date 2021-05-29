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
  var quiz1 = Quiz(quizContent: "문제1",
                   quizAnswer: "O")

  var quiz2 = Quiz(quizContent: "문제2",
                   quizAnswer: "X")

  var quiz3 = Quiz(quizContent: "문제3",
                   quizAnswer: "X")

  var quiz4 = Quiz(quizContent: "문제4",
                   quizAnswer: "X")

  var quiz5 = Quiz(quizContent: "문제5",
                   quizAnswer: "O")

  lazy var quiz = QuizModel(quiz: [quiz1,
                                   quiz2,
                                   quiz3,
                                   quiz4,
                                   quiz5])
  // 화면에서 발생하는 이벤트
  struct Input {
    let didTapYesButton: Observable<Bool>
    let didTapNoButton: Observable<Bool>
  }

  struct Output {
    let result: Driver<QuizModel>
  }

  func transform(input: Input) -> Output {
    let userAnswer = Observable.merge(input.didTapNoButton, input.didTapYesButton)
      .map { answer -> Bool in
        let userAnswer = answer ? true : false
        return userAnswer
      }

    let result = userAnswer.map { answer -> QuizModel in
      return self.quiz(answer: answer)
    }.asDriver(onErrorJustReturn: .init(quiz: []))

    return Output(result: result)
  }
}

extension QuizViewModel {
  private func loadQuiz() -> QuizModel? {
    let data = quiz as QuizModel
    return data
  }

  private func quiz(answer: Bool) -> QuizModel {
    if answer == false {
      return quiz
    }
    return quiz
  }

  func checkAnswer(quizAnswer: String,
                   users: String) -> Bool {
    if quizAnswer == users {
      return true
    }
    if quizAnswer == users {
      return false
    }

    return false
  }
}

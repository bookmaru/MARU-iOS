//
//  QuizViewModel.swift
//  MARU
//
//  Created by psychehose on 2021/04/10.
//
import Foundation

import RxSwift
import RxCocoa

class QuizViewModel: ViewModelType {
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

  }
  struct Output {
    let quizContent: Driver<String>
    let quizAnswer: Driver<String>
  }
  func transform(input: Input) -> Output {
    guard let data = loadJson() else {
      print("Error happen")
      return Output(quizContent: .never(),
                    quizAnswer: .never())
    }
    let quizContent = Driver<String>
      .just(data.quiz[0].quizContent)
    let quizAnswer = Driver<String>
      .just(data.quiz[0].quizAnswer)
    return Output(quizContent: quizContent,
                  quizAnswer: quizAnswer)
  }
}
extension QuizViewModel {
  private func loadJson() -> QuizModel? {
    let data = quiz as QuizModel
    return data
  }

  func checkAnswer(quizAnswer: String,
                   users: String) -> Bool {
    if quizAnswer == users {
      return true
    } else {
      return false
    }
  }
}

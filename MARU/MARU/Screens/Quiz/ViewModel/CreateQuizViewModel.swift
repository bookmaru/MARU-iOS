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

  struct Input {
    let quizProblem: Observable<[String]>
    let quizAnswer: Observable<[String]>
  }
  struct Output {
  }
  func transform(input: Input) -> Output {
    return Output()
  }
}

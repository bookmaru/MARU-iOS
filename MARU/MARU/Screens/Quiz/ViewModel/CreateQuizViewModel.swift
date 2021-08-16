//
//  CreateQuizViewModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/16.
//

import Foundation

import RxSwift
import RxCocoa

final class CreateQuizViewModel {

  struct Input {
    let viewdidLoad: PublishSubject<Void>
    let didTapCorrectButton: PublishSubject<String>
  }
  struct Output {
    let didCreate: Driver<UIViewController>
  }
  
//  func transform(input: Input) -> Output {
//    let didTapCorrectButton = 
//  }
}



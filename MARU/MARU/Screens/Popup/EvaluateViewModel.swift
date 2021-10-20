//
//  EvaluateViewModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/10/19.
//

import RxSwift

final class EvaluateViewModel {
  // groupID, leaderID, score
  struct Input {
    let didTapSubmitButton: Observable<(groupID: Int, leaderID: Int)>
    let score: Int
  }

  struct Output {
    let isConnected: Observable<Bool>
  }

  func transform(input: Input) -> Output {
    let score = input.score
    let isConnected = input.didTapSubmitButton
      .flatMap {
        NetworkService.shared.group.postEvaluate(groupID: $0, leaderID: $1, score: score)}
      .map { $0.status == 201 }

    return Output(isConnected: isConnected)
  }

}

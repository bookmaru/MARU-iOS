//
//  EvaluateViewModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/10/19.
//

import RxSwift

final class EvaluateViewModel {
  struct Submit {
    let groupID: Int
    let leaderID: Int
    let score: Int
  }

  struct Input {
    let didTapSubmitButton: Observable<Submit>
  }

  struct Output {
    let isConnected: Observable<Bool>
  }

  func transform(input: Input) -> Output {
    let isConnected = input.didTapSubmitButton
      .flatMap {
        NetworkService.shared.group.postEvaluate(groupID: $0.groupID, leaderID: $0.leaderID, score: $0.score)}
      .map { $0.status == 201 }

    return Output(isConnected: isConnected)
  }

}

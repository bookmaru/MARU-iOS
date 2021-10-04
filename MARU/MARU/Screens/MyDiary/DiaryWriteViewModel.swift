//
//  DiaryWriteViewModel.swift
//  MARU
//
//  Created by 오준현 on 2021/10/03.
//

import RxSwift

final class DiaryWriteViewModel {

  struct Input {
    let didTapDoneButton: Observable<(title: String, content: String)>
  }

  struct Output {
    let isSuccess: Observable<Bool>
  }

	private let groupID: Int

	init(groupID: Int) {
		self.groupID = groupID
	}

  func transform(input: Input) -> Output {
		let isSuccess = input.didTapDoneButton
			.flatMap { NetworkService.shared.diary.postDiary(groupID: self.groupID, title: $0, content: $1)}
			.map { $0.status == 201 }

    return Output(isSuccess: isSuccess)
  }
}

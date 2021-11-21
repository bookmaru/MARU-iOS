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
	private let isDiaryEdit: Bool
	private let info: DiaryInfo?

	init(groupID: Int, info: DiaryInfo?, isDiaryEdit: Bool = false) {
		self.groupID = groupID
		self.isDiaryEdit = isDiaryEdit
		self.info = info
	}

  func transform(input: Input) -> Output {
		let isSuccess = input.didTapDoneButton
			.flatMap { [weak self] title, content -> Observable<BaseResponseType<Int>> in
				guard let self = self else { return .empty() }
				if self.isDiaryEdit {
					return NetworkService.shared.diary.editDiary(groupID: self.info?.diaryID ?? 0, title: title, content: content)
				}
				return NetworkService.shared.diary.postDiary(groupID: self.groupID, title: title, content: content)
			}
			.map { $0.status == 201 || $0.status == 200 }

    return Output(isSuccess: isSuccess)
  }
}

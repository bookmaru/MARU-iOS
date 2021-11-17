//
//  MyLibraryViewModel.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import RxCocoa
import RxSwift

final class MyLibraryViewModel {

  struct Input {
    let viewWillApper: Observable<Void>
  }

  struct Output {
    let data: Driver<(user: User, library: [Library])?>
  }

  // TODO: - 서버 연결 상태 분기처리 할 것
  func transform(input: Input) -> Output {

    let viewWillApper = input.viewWillApper.share()

    let user = viewWillApper
      .flatMap(NetworkService.shared.auth.libraryUser)
      .compactMap { $0.data }
      .map { response -> User in
        return response
      }

    // 모임하고 싶은 책 리스트
    let bookList = viewWillApper
      .flatMap(NetworkService.shared.book.bookList)
      .map { response -> BookCaseModel? in
        return response.data
      }
    // 일기 리스트
    let diaryList = viewWillApper
      .flatMap(NetworkService.shared.diary.getDiaryList)
      .map { response -> Diaries? in
        return response.data
      }
    // 모임 리스트
    let bookGroup = viewWillApper
      .flatMap(NetworkService.shared.book.getGroup)
      .map { response -> KeepGroupModel? in
        return response.data
      }

    let library = Observable.combineLatest(bookList, diaryList, bookGroup)
      .map { bookList, diary, bookGroup -> [Library] in
        var library: [Library] = []
        library.append(.title(title: "담아둔 모임", isHidden: false))
        guard let bookGroup = bookGroup else { return library }
        library.append(.meeting(meeting: bookGroup))
        library.append(.title(title: "모임하고 싶은 책", isHidden: false))
        guard let bookList = bookList else { return library }
        library.append(.book(book: bookList))
        library.append(.title(title: "내 일기장", isHidden: false))
        guard let diary = diary else { return library }
        library.append(.diary(diary: diary))
        return library
      }

    let data = Observable.combineLatest(user, library)
      .map { user, library -> (user: User, library: [Library])? in
        return (user: user, library: library)
      }
      .asDriver(onErrorJustReturn: nil)

    return Output(data: data)
  }
}

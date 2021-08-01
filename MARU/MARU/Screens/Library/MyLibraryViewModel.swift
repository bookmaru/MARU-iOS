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
    let viewDidLoadPublisher: PublishSubject<Void>
  }

  struct Output {
    let user: Driver<User?>
    let data: Driver<[Library]>
  }

  func transform(input: Input) -> Output {

    let viewDidLoad = input.viewDidLoadPublisher.share()

    let user = viewDidLoad
      .flatMap { NetworkService.shared.auth.user() }
      .map { response -> User? in
        return response.data
      }
      .asDriver(onErrorJustReturn: nil)

    let bookList = viewDidLoad
      .flatMap { NetworkService.shared.book.bookList() }
      .map { response -> [String]? in
        return response.data
      }

    let diaryList = viewDidLoad
      .flatMap { NetworkService.shared.diary.getDiaryList() }
      .map { response -> [String]? in
        return response.data
      }

    let bookGroup = viewDidLoad
      .flatMap { NetworkService.shared.book.getGroup() }
      .map { response -> [String]? in
        return response.data
      }

    let data = Observable.combineLatest(bookList, diaryList, bookGroup)
      .map { bookList, diary, bookGroup -> [Library] in
        var library: [Library] = []
        library.append(.title(title: "모임하고 싶은 책", isHidden: true))
        library.append(.meeting(bookList ?? []))
        library.append(.title(title: "담아둔 모임", isHidden: true))
        library.append(.meeting(bookGroup ?? []))
        library.append(.title(title: "내 일기장", isHidden: false))
        library.append(.diary(diary ?? []))
        return library
      }
      .asDriver(onErrorJustReturn: [])

    return Output(user: user, data: data)
  }
}

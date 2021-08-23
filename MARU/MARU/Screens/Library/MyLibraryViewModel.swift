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
    // 프로필 정보에 해당하는 부분
    let user = viewDidLoad
      // map 사용하지 않는 이유 -> observable type으로 리턴되므로 이중으로 감싸진 형태
      // 따라서 flatmap 사용
      .flatMap { NetworkService.shared.auth.user() }
      .map { response -> User? in
        return response.data
      }
      .asDriver(onErrorJustReturn: nil)

    // 모임하고 싶은 책 리스트
    let bookList = viewDidLoad
      .flatMap {
        NetworkService.shared.book.bookList() }
      .map { response -> BookCaseModel? in
        return response.data
      }
    // 일기 리스트
    let diaryList = viewDidLoad
      .flatMap { NetworkService.shared.diary.getDiaryList() }
      .map { response -> Diaries? in
        return response.data
      }
    // 모임 리스트
    let bookGroup = viewDidLoad
      .flatMap { NetworkService.shared.book.getGroup() }
      .map { response -> KeepGroupModel? in
        return response.data
      }

    let data = Observable.combineLatest(bookList, diaryList, bookGroup)
      .map { bookList, diary, bookGroup -> [Library] in
        var library: [Library] = []
        library.append(.title(title: "담아둔 모임", isHidden: true))
        guard let bookGroup = bookGroup else { return [] }
        library.append(.meeting(meeting: bookGroup))
        // 임시 데이터 넣은 코드, 지우지 말아주세요.
        /* library.append(.meeting(meeting: .init(keepGroup: [.init(groupID: 3,
            image: "image120", title: "aaa", author: "aaa", description: "aaa",
            userID: 3, nickName: "aaa", leaderScore: 2, isLeader: false)]))) */
        library.append(.title(title: "모임하고 싶은 책", isHidden: false))
        guard let bookList = bookList else { return [] }
        library.append(.book(book: bookList))
        library.append(.title(title: "내 일기장", isHidden: false))
        guard let diary = diary else { return [] }
        library.append(.diary(diary: diary))
        return library
      }
      .asDriver(onErrorJustReturn: [])

    return Output(user: user, data: data)
  }
}

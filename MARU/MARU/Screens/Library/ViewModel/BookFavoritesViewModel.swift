//
//  BookFavoritesViewModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/19.
//

import RxCocoa
import RxSwift

final class BookFavoritesViewModel {

  struct Input {
    let viewDidLoadPublisher: PublishSubject<Void>
  }
  struct Output {
    let data: Driver<BookCaseModel?>
  }
  func transfrom(input: Input) -> Output {
    let viewDidLoad = input.viewDidLoadPublisher.share()
    let bookList = viewDidLoad
      .flatMap { NetworkService.shared.book.bookList() }
      .map { response -> BookCaseModel? in
        return response.data
      }
      .asDriver(onErrorJustReturn: nil)
    return Output(data: bookList)
  }
}

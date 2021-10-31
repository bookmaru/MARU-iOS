//
//  BookAlertViewModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/10/31.
//

import RxSwift

struct AlertButtonDTO {
  let author: String
  let category: String
  let imageURL: String
  let isbn: Int
  let title: String
}

final class BookAlertViewModel {

  struct Input {
    let didTapSubmitButton: Observable<AlertButtonDTO>
  }

  struct Output {
    let isSuccess: Observable<Bool>
  }

  func transform(input: Input) -> Output {
    let isSuccess = input.didTapSubmitButton.flatMap {
      NetworkService.shared.book.addBook(
        author: $0.author,
        category: $0.category,
        imageURL: $0.imageURL,
        isbn: $0.isbn,
        title: $0.title
      )
    }
      .map { $0.status == 201}
    return Output(isSuccess: isSuccess)
  }

}

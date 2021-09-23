//
//  ResultBookViewModel.swift
//  MARU
//
//  Created by 이윤진 on 2021/09/22.
//

import UIKit

import RxCocoa
import RxSwift

final class ResultBookViewModel: ViewModelType {
  struct Input {
    let viewTrigger: Observable<Void>
    let keyword: String?
    let tapCancelButton: Driver<Void>
    let tapTextField: Driver<Void>
  }

  struct Output {
    let result: Driver<[BookModel]>
    let cancel: Driver<Void>
    let reSearch: Driver<Void>
    let errorMessage: Observable<Error>
  }

  func transform(input: Input) -> Output {
    let errorMessage = PublishSubject<Error>()

    let result = input.viewTrigger
      .flatMap {
        // MARK: - 페이징처리.
        NetworkService.shared.search.bookSearch(queryString: input.keyword ?? "", page: 1) }
      .map { response -> BaseReponseType<Books> in

        guard 200 ..< 300 ~= response.status else {
          errorMessage.onNext(
            MaruError.serverError(response.status)
          )
          return response
        }
        return response
      }
      .map { $0.data?.books.map { BookModel($0)} }
      .map { bookModel -> [BookModel] in
        guard let bookModel = bookModel else { return [] }
        return bookModel
      }
      .asDriver(onErrorJustReturn: [])

    let cancel = input.tapCancelButton
      .asDriver()

    let reSearch = input.tapTextField
      .asDriver()

    return Output(result: result,
                  cancel: cancel,
                  reSearch: reSearch,
                  errorMessage: errorMessage)
  }
}

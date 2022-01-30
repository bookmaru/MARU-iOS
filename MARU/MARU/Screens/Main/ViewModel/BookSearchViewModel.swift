//
//  BookSearchViewModel.swift
//  MARU
//
//  Created by 김호세 on 2021/09/27.
//

import RxCocoa
import RxSwift

final class BookSearchViewModel: ViewModelType {

  func transform(input: Input) -> Output {
    let errorMessage = PublishSubject<Error>()
		let reSearchFlag = PublishSubject<Void>()
    let otherKeywordSearch = PublishSubject<String>()
    var currentKeyword: String = ""
    var pageNumber: Int = 1

    let firstSearch = Observable.merge(input.viewTrigger, otherKeywordSearch)
			.take(1)
      .do(onNext: { currentKeyword = $0 })
      .flatMap { NetworkService.shared.search.bookSearch(queryString: $0, page: 1) }
      .map { response -> BaseResponseType<Books> in

        guard 200 ..< 300 ~= response.status else {
          errorMessage.onNext(
            MaruError.serverError(response.status)
          )
          return response
        }
        return response
      }
      .map { $0.data?.books.map { BookModel($0) }}
      .map { bookModel -> [BookModel] in
        guard let bookModel = bookModel else { return [] }
        return bookModel
      }
      .do(onNext: {
        if !$0.isEmpty {
          pageNumber = 2
        }
      })
      .asDriver(onErrorJustReturn: [])

    let fetchMore = input.fetchMore
      .flatMap { NetworkService.shared.search.bookSearch(queryString: currentKeyword, page: pageNumber) }
      .map { response -> BaseResponseType<Books> in

        guard 200 ..< 300 ~= response.status else {
          errorMessage.onNext(
            MaruError.serverError(response.status)
          )
          return response
        }
        return response
      }
      .map { $0.data?.books.map { BookModel($0) }}
      .map { bookModel -> [BookModel] in
        guard let bookModel = bookModel else { return [] }
        return bookModel
      }
      .do(onNext: {
        if !$0.isEmpty {
          pageNumber += 1
        }
      })
      .asDriver(onErrorJustReturn: [])

    let cancel = input.tapCancelButton
      .asDriver(onErrorJustReturn: ())

    let reSearch = input.tapSearchButton
      .withLatestFrom(input.writeText)
				.do(onNext: {
					currentKeyword = $0
					reSearchFlag.onNext(())
				})
				.flatMap { NetworkService.shared.search.bookSearch(queryString: $0, page: 1) }
				.map { response -> BaseResponseType<Books> in

					guard 200 ..< 300 ~= response.status else {
						errorMessage.onNext(
							MaruError.serverError(response.status)
						)
						return response
					}
					return response
				}
				.map { $0.data?.books.map { BookModel($0) }}
				.map { bookModel -> [BookModel] in
					guard let bookModel = bookModel else { return [] }
					return bookModel
				}
				.do(onNext: {
					if !$0.isEmpty {
						pageNumber = 2
					}
				})
				.asDriver(onErrorJustReturn: [])

		let result = Driver.merge(firstSearch, fetchMore, reSearch)

    return Output(
      result: result,
      cancel: cancel,
			reSearch: reSearchFlag.asDriver(onErrorJustReturn: ()),
      errorMessage: errorMessage
    )
  }
}

extension BookSearchViewModel {
  struct Input {
    let viewTrigger: Observable<String>
    let tapCancelButton: Observable<Void>
    let writeText: Observable<String>
    let tapSearchButton: Observable<Void>
    let fetchMore: Observable<Void>
  }

  struct Output {
    let result: Driver<[BookModel]>
    let cancel: Driver<Void>
    let reSearch: Driver<Void>
    let errorMessage: Observable<Error>
  }

}

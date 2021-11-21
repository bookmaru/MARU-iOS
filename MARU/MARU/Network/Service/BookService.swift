//
//  BookService.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import Moya
import RxSwift

protocol BookServiceType {
  func bookList() -> Observable<BaseResponseType<BookCaseModel>>
  func getGroup() -> Observable<BaseResponseType<KeepGroupModel>>
  func addGroup(groupID: Int) -> Observable<BaseResponseType<Int>>
  func addBook(
    author: String,
    category: String,
    imageURL: String,
    isbn: Int,
    title: String
  ) -> Observable<BaseResponseType<Int>>
}

final class BookService: BookServiceType {
  private let router = MoyaProvider<BookRouter>(plugins: [NetworkLoggerPlugin(verbose: true)])

  func bookList() -> Observable<BaseResponseType<BookCaseModel>> {
    return router.rx
      .request(.get)
      .asObservable()
      .map(BaseResponseType<BookCaseModel>.self)
  }
  func getGroup() -> Observable<BaseResponseType<KeepGroupModel>> {
    return router.rx
      .request(.group)
      .asObservable()
      .map(BaseResponseType<KeepGroupModel>.self)
  }
  func addGroup(groupID: Int) -> Observable<BaseResponseType<Int>> {
    return router.rx
      .request(.addGroup(groupID: groupID))
      .asObservable()
      .map(BaseResponseType<Int>.self)
  }
  func addBook(
    author: String,
    category: String,
    imageURL: String,
    isbn: Int,
    title: String
  ) -> Observable<BaseResponseType<Int>> {
    return router.rx
      .request(.addBook(author: author, category: category, imageURL: imageURL, isbn: isbn, title: title))
      .asObservable()
      .map(BaseResponseType<Int>.self)
  }
}

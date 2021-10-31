//
//  BookService.swift
//  MARU
//
//  Created by 오준현 on 2021/08/01.
//

import Moya
import RxSwift

protocol BookServiceType {
  func bookList() -> Observable<BaseReponseType<BookCaseModel>>
  func getGroup() -> Observable<BaseReponseType<KeepGroupModel>>
  func addGroup(groupID: Int) -> Observable<BaseReponseType<Int>>
  func addBook(author: String, category: String, imageURL: String, isbn: Int, title: String) -> Observable<BaseReponseType<Int>>
}

final class BookService: BookServiceType {
  private let router = MoyaProvider<BookRouter>(plugins: [NetworkLoggerPlugin(verbose: true)])

  func bookList() -> Observable<BaseReponseType<BookCaseModel>> {
    return router.rx
      .request(.get)
      .asObservable()
      .map(BaseReponseType<BookCaseModel>.self)
      .catchError { error -> Observable<BaseReponseType<BookCaseModel>> in
        print("ddd", error)
        return .empty()
      }

  }
  func getGroup() -> Observable<BaseReponseType<KeepGroupModel>> {
    return router.rx
      .request(.group)
      .asObservable()
      .map(BaseReponseType<KeepGroupModel>.self)
      .catchError { error -> Observable<BaseReponseType<KeepGroupModel>> in
        print("ddd", error)
        return .empty()
      }
  }
  func addGroup(groupID: Int) -> Observable<BaseReponseType<Int>> {
    return router.rx
      .request(.addGroup(groupID: groupID))
      .asObservable()
      .map(BaseReponseType<Int>.self)
      .catchError { error -> Observable<BaseReponseType<Int>> in
        print("ddd", error)
        return .empty()
      }

  }
  func addBook(
    author: String,
    category: String,
    imageURL: String,
    isbn: Int,
    title: String
  ) -> Observable<BaseReponseType<Int>> {
    return router.rx
      .request(.addBook(author: author, category: category, imageURL: imageURL, isbn: isbn, title: title))
      .asObservable()
      .map(BaseReponseType<Int>.self)
  }
}

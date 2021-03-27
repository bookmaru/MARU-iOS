//
//  ViewModelType.swift
//  MARU
//
//  Created by 오준현 on 2021/03/27.
//

protocol ViewModelType {
  associatedtype Input
  associatedtype Output

  func transform(input: Input) -> Output
}

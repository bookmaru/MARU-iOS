//
//  MaruError.swift
//  MARU
//
//  Created by psychehose on 2021/08/15.
//

import Foundation

enum MaruError: Error {
  case serverError(_ code: Int)
}

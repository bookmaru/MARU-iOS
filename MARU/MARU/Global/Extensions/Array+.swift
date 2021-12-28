//
//  Array+.swift
//  MARU
//
//  Created by 이윤진 on 2021/12/29.
//

import UIKit

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

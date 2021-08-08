//
//  String+.swift
//  MARU
//
//  Created by 오준현 on 2021/05/08.
//

import Foundation

extension String {
  var intValue: Int {
    return Int(self) ?? -1
  }
}

extension String {
  var date: Date {
    let dateString = self.split(separator: "T")
    let timeString = dateString[1].split(separator: ".")[0]
    let date = String(dateString[0] + " " + timeString)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.date(from: date) ?? Date()
  }
}

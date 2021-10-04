//
//  Date+.swift
//  MARU
//
//  Created by 오준현 on 2021/08/07.
//

import Foundation

extension Date {
  var isExpired: Bool {
    return self < Date(timeInterval: -60 * 60 * 24, since: Date())
  }

  var chatTime: String {
    let calendar = Calendar.current
    let now = Date() // 서버시간이 9시간 밀려서 뺌
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(
      unitFlags,
      from: self,
      to: now,
      options: []
    )

    // 남은 일수 계산
    if let day = components.day, day >= 1 {
        let remain = day
        return "\(remain)일 전"
    }

    if let hour = components.hour, hour >= 2 {
        return "\(hour)시간 전"
    }

    if let hour = components.hour, hour >= 1 {
        return "한 시간 전"
    }

    if let minute = components.minute, minute >= 2 {
        return "\(minute)분 전"
    }

    if let minute = components.minute, minute >= 1 {
        return "1분 전"
    }

    if let second = components.second, second >= 1 {
        return "\(second)초 전"
    }

    return "지금"
  }

}

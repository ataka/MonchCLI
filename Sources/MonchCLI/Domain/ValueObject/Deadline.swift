//
//  Deadline.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/14.
//

import Foundation

enum Deadline: Int, CaseIterable {
    case today
    case aFewDaysLater
    case twoWeeksLater

    var string: String {
        switch self {
        case .today:
            return "急いでいます。今日中で!!"
        case .aFewDaysLater:
            return "時間のある時にやって欲しいです。二営業日以"
        case .twoWeeksLater:
            return "急いでいません。でも忘れてもらっては困ります。二週間以内に。"
        }
    }

    func getDate(_ now: Date = Date()) -> Date? {
        var adding = DateComponents()
        switch self {
        case .today:
            adding.hour = 2
        case .aFewDaysLater:
            switch Calendar.current.dateComponents([.weekday], from: now).weekday {
            case 1, 2, 3, 4: // Sunday, Monday, Tuesday, Wednesday
                adding.day = 2
            case 5, 6: // Thursday, Friday
                adding.day = 4
            case 7: // Saturday
                adding.day = 3
            default:
                fatalError("NO DAY of WEEK")
            }
        case .twoWeeksLater:
            adding.day = 14
        }
        return Calendar.current.date(byAdding: adding, to: now)
    }
}

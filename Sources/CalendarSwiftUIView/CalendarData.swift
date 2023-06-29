//
//  MonthStruct.swift
//  CalendarSwiftUIView
//
//  Created by P.Nam on 28/06/2023.
//

import Foundation

internal struct MonthStruct {
    var monthType: MonthType
    var dayInt : Int
    var day: String {
        String(dayInt)
    }
}

internal extension MonthStruct {
    enum MonthType: Int {
        case previous = -1
        case current = 0
        case next = 1
    }
}

public enum WeekStartCalendar {
    case sunday
    case monday
    case saturday
    
    var start: Int {
        switch self {
        case .sunday:
            return 1
        case .monday:
            return 2
        case .saturday:
            return 0
        }
    }
    
    func daysOfWeak(dayOfWeek: DayOfWeek) -> [String] {
        switch self {
        case .sunday:
            return [dayOfWeek.sunday, dayOfWeek.monday, dayOfWeek.tuesday, dayOfWeek.wednesday, dayOfWeek.thursday, dayOfWeek.friday, dayOfWeek.saturday]
        case .monday:
            return [dayOfWeek.monday, dayOfWeek.tuesday, dayOfWeek.wednesday, dayOfWeek.thursday, dayOfWeek.friday, dayOfWeek.saturday, dayOfWeek.sunday]
        case .saturday:
            return [dayOfWeek.saturday, dayOfWeek.sunday, dayOfWeek.monday, dayOfWeek.tuesday, dayOfWeek.wednesday, dayOfWeek.thursday, dayOfWeek.friday]
        }
    }
}

public extension WeekStartCalendar {
    struct DayOfWeek {
        let sunday: String
        let monday: String
        let tuesday: String
        let wednesday: String
        let thursday: String
        let friday: String
        let saturday: String
        
        static let collapse: Self = .init(
            sunday: "Sun",
            monday: "Mon",
            tuesday: "Tue",
            wednesday: "Wed",
            thursday: "Thu",
            friday: "Fri",
            saturday: "Sat"
        )
        
        static let expand: Self = .init(
            sunday: "Sunday",
            monday: "Monday",
            tuesday: "Tuesday",
            wednesday: "Wednesday",
            thursday: "Thursday",
            friday: "Friday",
            saturday: "Saturday"
        )
    }
}

//
//  CalendarUtil.swift
//  iOSFootball2AM
//
//  Created by P.Nam on 27/06/2023.
//

import Foundation

final class CalendarUtil {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    func monthYearString(_ date: Date) -> String {
        dateFormatter.dateFormat = "MMM, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func month(_ date: Date) -> Int {
        let components = calendar.dateComponents([.month], from: date)
        return components.month!
    }
    
    func modifyDay(of date: Date, to desiredDay: Int) -> Date {
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        dateComponents.hour = 7
        dateComponents.day = desiredDay
        return calendar.date(from: dateComponents)!
    }
    
    func plusMonth(_ date: Date) -> Date {
        calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(_ date: Date) -> Date {
        calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func modifyMonth(by date: Date, month: Int) -> Date {
        calendar.date(byAdding: .month, value: month, to: date)!
    }
    
    func daysInMonth(_ date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(_ date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(_ date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(_ date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
    func compareDates(date1: Date, date2: Date) -> Bool {
        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
        return (components1.day, components1.month, components1.year) == (components2.day, components2.month, components2.year)
    }
}

//
//  DateController.swift
//  CalendarSwiftUIView
//
//  Created by P.Nam on 27/06/2023.
//

import SwiftUI

@available(iOS 14.0, *)
internal final class DateController: ObservableObject {
    private var calendarUtil: CalendarUtil
    @Binding var date: Date
    @Binding var selectedDate: Date
    @Published var dates: [Date]
    
    var monthYearString: String {
        calendarUtil.monthYearString(date)
    }
    
    private init(calendarUtil: CalendarUtil, date: Binding<Date>, selectedDate: Binding<Date>, dates: [Date]) {
        self.calendarUtil = calendarUtil
        self._date = date
        self._selectedDate = selectedDate
        self.dates = dates
    }
    
    convenience init(date: Binding<Date>, selectedDate: Binding<Date>) {
        let calendarUtil = CalendarUtil()
        let currentDate = date.wrappedValue
        self.init(
            calendarUtil: calendarUtil,
            date: date,
            selectedDate: selectedDate,
            dates: [calendarUtil.minusMonth(currentDate), currentDate, calendarUtil.plusMonth(currentDate)]
        )
    }
    
    func resetDates() {
        dates = [calendarUtil.minusMonth(date), date, calendarUtil.plusMonth(date)]
    }
    
    func firstOfMonth(_ date: Date) -> Date {
        calendarUtil.firstOfMonth(date)
    }
    
    func prevMonth(of date: Date) -> Date {
        calendarUtil.minusMonth(date)
    }
    
    func nextMonth(of date: Date) -> Date {
        calendarUtil.plusMonth(date)
    }
    
    func weekDay(_ date: Date) -> Int {
        calendarUtil.weekDay(date)
    }
    
    func daysInMonth(_ date: Date) -> Int {
        calendarUtil.daysInMonth(date)
    }
    
    func dayOfMonth(_ date: Date) -> Int {
        calendarUtil.dayOfMonth(date)
    }
    
    func month(_ date: Date) -> Int {
        calendarUtil.month(date)
    }
    
    func modifyDay(of date: Date, to desiredDay: Int) -> Date {
        calendarUtil.modifyDay(of: date, to: desiredDay)
    }
    
    func modifyMonth(by date: Date, month: Int) -> Date {
        calendarUtil.modifyMonth(by: date, month: month)
    }
    
    func compareDates(date1: Date, date2: Date) -> Bool {
        calendarUtil.compareDates(date1: date1, date2: date2)
    }
}

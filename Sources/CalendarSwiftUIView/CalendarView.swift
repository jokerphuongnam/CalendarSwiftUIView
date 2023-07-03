//
//  CalendarView.swift
//  CalendarSwiftUIView
//
//  Created by P.Nam on 27/06/2023.
//

import SwiftUI

@available(iOS 14.0, *)
public struct CalendarView<Header, SelectedBackground>: View where Header: View, SelectedBackground: View {
    @StateObject private var controller: DateController
    @State private var index: Int = 0
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    private let weekStartCalendar: WeekStartCalendar?
    private let dayOfWeek: WeekStartCalendar.DayOfWeek?
    private let header: (_ prevAction: @escaping () -> Void, _ nextAction: @escaping () -> Void) -> Header
    
    // MARK: - Config
    private let dayOfWeekFont: SwiftUI.Font?
    private let dayOfWeekColor: Color?
    private let selectedFont: SwiftUI.Font?
    private let currentMonthUnSelectedFont: SwiftUI.Font?
    private let unSelectedFont: SwiftUI.Font?
    private let selectedColor: Color?
    private let currentMonthUnSelectedColor: Color?
    private let unSelectedColor: Color?
    private let itemPadding: CGFloat?
    private let selectedBackground: (() -> SelectedBackground)?
    
    public var body: some View {
        VStack {
            header {
                modifyMonth(-1)
            } _: {
                modifyMonth(1)
            }
            
            dayOfWeekStack
            
            calendarGrids
        }
        .onAppear {
            controller.date = controller.selectedDate
        }
    }
}

@available(iOS 14.0, *)
private extension CalendarView {
    var dayOfWeekStack: some View {
        HStack(spacing: 0) {
            ForEach((weekStartCalendar ?? .monday).daysOfWeak(dayOfWeek: dayOfWeek ?? .collapse), id: \.self) { label in
                Text(label)
                    .font(dayOfWeekFont)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .foregroundColor(dayOfWeekColor)
    }
    
    var calendarGrids: some View {
        PagingView(
            index: Binding {
                controller.dates.firstIndex(of: controller.date) ?? 0
            } set: { newValue in
                if (0..<controller.dates.count).contains(newValue) {
                    controller.date = controller.dates[newValue]
                    controller.resetDates()
                }
            },
            count: controller.dates.count) { index in
                let date = controller.dates[index]
                calendarGrid(date: date)
                    .tag(date)
            }
            .getScrollProxy { scrollViewProxy in
                self.scrollViewProxy = scrollViewProxy
            }
    }
    
    func calendarGrid(date: Date) -> some View {
        VStack(spacing: 2) {
            let daysInMonth = controller.daysInMonth(date)
            let firstDayOfMonth = controller.firstOfMonth(date)
            let startingSpaces = controller.weekDay(firstDayOfMonth)
            let prevMonth = controller.prevMonth(of: date)
            let daysInPrevMonth = controller.daysInMonth(prevMonth)
            
            ForEach(0..<6, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { column in
                        let count = column + (row * 7)
                        CalendarCell(
                            controller: controller,
                            date: date,
                            count: count + (weekStartCalendar ?? .monday).start,
                            startingSpaces: startingSpaces,
                            daysInMonth: daysInMonth,
                            daysInPrevMonth: daysInPrevMonth,
                            modifyMonthCompletion: modifyMonth,
                            selectedFont: selectedFont ?? .body,
                            unSelectedFont: unSelectedFont ?? .body,
                            selectedColor: selectedColor ?? .white,
                            currentMonthUnSelectedColor: currentMonthUnSelectedColor ?? .black,
                            unSelectedColor: unSelectedColor ?? .gray,
                            itemPadding: itemPadding ?? 2,
                            selectedBackground: selectedBackground
                        )
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            Spacer()
        }
    }
    
    func modifyMonth(_ addingValue: Int) {
        if addingValue == -1 {
            withAnimation(.easeInOut(duration: 0.4)) {
                scrollViewProxy?.scrollTo(0)
            }
            controller.date = controller.dates[0]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                controller.resetDates()
                scrollViewProxy?.scrollTo(1)
            }
        } else if addingValue == 1 {
            withAnimation(.easeInOut(duration: 0.4)) {
                scrollViewProxy?.scrollTo(2)
            }
            controller.date = controller.dates[2]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                controller.resetDates()
                scrollViewProxy?.scrollTo(1)
            }
        }
    }
}

@available(iOS 14.0, *)
public extension CalendarView where SelectedBackground == Circle {
    init(
        date: Binding<Date>,
        selectedDate: Binding<Date>,
        @ViewBuilder header: @escaping (_ prevAction: @escaping () -> Void, _ nextAction: @escaping () -> Void) -> Header
    ) {
        self.init(
            controller: DateController(date: date, selectedDate: selectedDate),
            weekStartCalendar: nil,
            dayOfWeek: nil,
            header: header,
            dayOfWeekFont: nil,
            dayOfWeekColor: nil,
            selectedFont: nil,
            currentMonthUnSelectedFont: nil,
            unSelectedFont: nil,
            selectedColor: nil,
            currentMonthUnSelectedColor: nil,
            unSelectedColor: nil,
            itemPadding: nil) {
                Circle()
            }
    }
}

@available(iOS 14.0, *)
public extension CalendarView {
    init(
        date: Binding<Date>,
        selectedDate: Binding<Date>,
        @ViewBuilder header: @escaping (_ prevAction: @escaping () -> Void, _ nextAction: @escaping () -> Void) -> Header
    ) {
        self.init(
            controller: DateController(date: date, selectedDate: selectedDate),
            weekStartCalendar: nil,
            dayOfWeek: nil,
            header: header,
            dayOfWeekFont: nil,
            dayOfWeekColor: nil,
            selectedFont: nil,
            currentMonthUnSelectedFont: nil,
            unSelectedFont: nil,
            selectedColor: nil,
            currentMonthUnSelectedColor: nil,
            unSelectedColor: nil,
            itemPadding: nil,
            selectedBackground: nil
        )
    }
}

@available(iOS 14.0, *)
public extension CalendarView {
    func weekStartCalendar(_ weekStartCalendar: WeekStartCalendar? = nil) -> Self {
        .init(
            controller: controller,
            weekStartCalendar: weekStartCalendar,
            dayOfWeek: dayOfWeek,
            header: header,
            dayOfWeekFont: dayOfWeekFont,
            dayOfWeekColor: dayOfWeekColor,
            selectedFont: selectedFont,
            currentMonthUnSelectedFont: currentMonthUnSelectedFont,
            unSelectedFont: unSelectedFont,
            selectedColor: selectedColor,
            currentMonthUnSelectedColor: currentMonthUnSelectedColor,
            unSelectedColor: unSelectedColor,
            itemPadding: itemPadding,
            selectedBackground: selectedBackground
        )
    }
    
    func dayOfWeek(_ dayOfWeek: WeekStartCalendar.DayOfWeek? = nil) -> Self {
        .init(
            controller: controller,
            weekStartCalendar: weekStartCalendar,
            dayOfWeek: dayOfWeek,
            header: header,
            dayOfWeekFont: dayOfWeekFont,
            dayOfWeekColor: dayOfWeekColor,
            selectedFont: selectedFont,
            currentMonthUnSelectedFont: currentMonthUnSelectedFont,
            unSelectedFont: unSelectedFont,
            selectedColor: selectedColor,
            currentMonthUnSelectedColor: currentMonthUnSelectedColor,
            unSelectedColor: unSelectedColor,
            itemPadding: itemPadding,
            selectedBackground: selectedBackground
        )
    }
    
    func dayOfWeekFont(_ dayOfWeekFont: SwiftUI.Font? = nil) -> Self {
        .init(
            controller: controller,
            weekStartCalendar: weekStartCalendar,
            dayOfWeek: dayOfWeek,
            header: header,
            dayOfWeekFont: dayOfWeekFont,
            dayOfWeekColor: dayOfWeekColor,
            selectedFont: selectedFont,
            currentMonthUnSelectedFont: currentMonthUnSelectedFont,
            unSelectedFont: unSelectedFont,
            selectedColor: selectedColor,
            currentMonthUnSelectedColor: currentMonthUnSelectedColor,
            unSelectedColor: unSelectedColor,
            itemPadding: itemPadding,
            selectedBackground: selectedBackground
        )
    }
    
    func dayOfWeekColor(_ dayOfWeekColor: Color? = nil) -> Self {
        .init(
            controller: controller,
            weekStartCalendar: weekStartCalendar,
            dayOfWeek: dayOfWeek,
            header: header,
            dayOfWeekFont: dayOfWeekFont,
            dayOfWeekColor: dayOfWeekColor,
            selectedFont: selectedFont,
            currentMonthUnSelectedFont: currentMonthUnSelectedFont,
            unSelectedFont: unSelectedFont,
            selectedColor: selectedColor,
            currentMonthUnSelectedColor: currentMonthUnSelectedColor,
            unSelectedColor: unSelectedColor,
            itemPadding: itemPadding,
            selectedBackground: selectedBackground
        )
    }
    
    func selectedFont(_ selectedFont: SwiftUI.Font? = nil) -> Self {
        .init(
            controller: controller,
            weekStartCalendar: weekStartCalendar,
            dayOfWeek: dayOfWeek,
            header: header,
            dayOfWeekFont: dayOfWeekFont,
            dayOfWeekColor: dayOfWeekColor,
            selectedFont: selectedFont,
            currentMonthUnSelectedFont: currentMonthUnSelectedFont,
            unSelectedFont: unSelectedFont,
            selectedColor: selectedColor,
            currentMonthUnSelectedColor: currentMonthUnSelectedColor,
            unSelectedColor: unSelectedColor,
            itemPadding: itemPadding,
            selectedBackground: selectedBackground
        )
    }
    
    func unSelectedFont(_ unSelectedFont: SwiftUI.Font? = nil) -> Self {
        .init(
            controller: controller,
            weekStartCalendar: weekStartCalendar,
            dayOfWeek: dayOfWeek,
            header: header,
            dayOfWeekFont: dayOfWeekFont,
            dayOfWeekColor: dayOfWeekColor,
            selectedFont: selectedFont,
            currentMonthUnSelectedFont: currentMonthUnSelectedFont,
            unSelectedFont: unSelectedFont,
            selectedColor: selectedColor,
            currentMonthUnSelectedColor: currentMonthUnSelectedColor,
            unSelectedColor: unSelectedColor,
            itemPadding: itemPadding,
            selectedBackground: selectedBackground
        )
    }
    
    func selectedColor(_ selectedColor: Color? = nil) -> Self {
        .init(
            controller: controller,
            weekStartCalendar: weekStartCalendar,
            dayOfWeek: dayOfWeek,
            header: header,
            dayOfWeekFont: dayOfWeekFont,
            dayOfWeekColor: dayOfWeekColor,
            selectedFont: selectedFont,
            currentMonthUnSelectedFont: currentMonthUnSelectedFont,
            unSelectedFont: unSelectedFont,
            selectedColor: selectedColor,
            currentMonthUnSelectedColor: currentMonthUnSelectedColor,
            unSelectedColor: unSelectedColor,
            itemPadding: itemPadding,
            selectedBackground: selectedBackground
        )
    }
    
    func currentMonthUnSelectedColor(_ currentMonthUnSelectedColor: Color? = nil) -> Self {
        .init(
            controller: controller,
            weekStartCalendar: weekStartCalendar,
            dayOfWeek: dayOfWeek,
            header: header,
            dayOfWeekFont: dayOfWeekFont,
            dayOfWeekColor: dayOfWeekColor,
            selectedFont: selectedFont,
            currentMonthUnSelectedFont: currentMonthUnSelectedFont,
            unSelectedFont: unSelectedFont,
            selectedColor: selectedColor,
            currentMonthUnSelectedColor: currentMonthUnSelectedColor,
            unSelectedColor: unSelectedColor,
            itemPadding: itemPadding,
            selectedBackground: selectedBackground
        )
    }
    
    func unSelectedColor(_ unSelectedColor: Color? = nil) -> Self {
        .init(
            controller: controller,
            weekStartCalendar: weekStartCalendar,
            dayOfWeek: dayOfWeek,
            header: header,
            dayOfWeekFont: dayOfWeekFont,
            dayOfWeekColor: dayOfWeekColor,
            selectedFont: selectedFont,
            currentMonthUnSelectedFont: currentMonthUnSelectedFont,
            unSelectedFont: unSelectedFont,
            selectedColor: selectedColor,
            currentMonthUnSelectedColor: currentMonthUnSelectedColor,
            unSelectedColor: unSelectedColor,
            itemPadding: itemPadding,
            selectedBackground: selectedBackground
        )
    }
    
    func itemPadding(_ itemPadding: CGFloat? = nil) -> Self {
        .init(
            controller: controller,
            weekStartCalendar: weekStartCalendar,
            dayOfWeek: dayOfWeek,
            header: header,
            dayOfWeekFont: dayOfWeekFont,
            dayOfWeekColor: dayOfWeekColor,
            selectedFont: selectedFont,
            currentMonthUnSelectedFont: currentMonthUnSelectedFont,
            unSelectedFont: unSelectedFont,
            selectedColor: selectedColor,
            currentMonthUnSelectedColor: currentMonthUnSelectedColor,
            unSelectedColor: unSelectedColor,
            itemPadding: itemPadding,
            selectedBackground: selectedBackground
        )
    }
    
    func selectedBackground(@ViewBuilder selectedBackground: @escaping () -> SelectedBackground) -> Self {
        .init(
            controller: controller,
            weekStartCalendar: weekStartCalendar,
            dayOfWeek: dayOfWeek,
            header: header,
            dayOfWeekFont: dayOfWeekFont,
            dayOfWeekColor: dayOfWeekColor,
            selectedFont: selectedFont,
            currentMonthUnSelectedFont: currentMonthUnSelectedFont,
            unSelectedFont: unSelectedFont,
            selectedColor: selectedColor,
            currentMonthUnSelectedColor: currentMonthUnSelectedColor,
            unSelectedColor: unSelectedColor,
            itemPadding: itemPadding,
            selectedBackground: selectedBackground
        )
    }
}

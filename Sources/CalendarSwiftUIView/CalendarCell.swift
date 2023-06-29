//
//  CalendarCell.swift
//  CalendarSwiftUIView
//
//  Created by P.Nam on 27/06/2023.
//

import SwiftUI

@available(iOS 14.0, *)
internal struct CalendarCell<SelectedBackground>: View where SelectedBackground: View {
    @StateObject var controller: DateController
    let date: Date
    let count : Int
    let startingSpaces : Int
    let daysInMonth : Int
    let daysInPrevMonth : Int
    let modifyMonthCompletion: ((_ addingValue: Int) -> Void)?
    
    // MARK: - Config
    var selectedFont: SwiftUI.Font
    var unSelectedFont: SwiftUI.Font
    var selectedColor: Color
    var currentMonthUnSelectedColor: Color
    var unSelectedColor: Color
    var itemPadding: CGFloat
    var selectedBackground: (() -> SelectedBackground)?
    
    var body: some View {
        let monthStruct = monthStruct
        Button {
            switch monthStruct.monthType {
            case .previous:
                let prevMonth = controller.prevMonth(of: controller.date)
                let dayChange = controller.modifyDay(of: prevMonth, to: monthStruct.dayInt)
                controller.selectedDate = dayChange
                modifyMonthCompletion?(-1)
            case .current:
                controller.selectedDate = controller.modifyDay(of: controller.date, to: monthStruct.dayInt)
            case .next:
                let nextMonth = controller.nextMonth(of: controller.date)
                let dayChange = controller.modifyDay(of: nextMonth, to: monthStruct.dayInt)
                controller.selectedDate = dayChange
                modifyMonthCompletion?(1)
            }
        } label: {
            let text = Text(monthStruct.day)
                .frame(maxWidth: .infinity, alignment: .center)
                .aspectRatio(1, contentMode: .fit)
                .fixedSize(horizontal: false, vertical: true)
                .padding(itemPadding)
            if isSelected(monthStruct) {
                text
                    .font(selectedFont)
                    .foregroundColor(selectedColor)
                    .background(selectedBackground?())
            } else {
                text
                    .padding(1)
                    .font(unSelectedFont)
                    .foregroundColor(textColor(monthStruct.monthType))
            }
        }
    }
}

@available(iOS 14.0, *)
private extension CalendarCell {
    private func isSelected(_ monthStruct: MonthStruct) -> Bool {
        controller.compareDates(date1: controller.modifyDay(of: controller.modifyMonth(by: date, month: monthStruct.monthType.rawValue), to: monthStruct.dayInt), date2: controller.selectedDate)
    }
    
    private func textColor(_ type: MonthStruct.MonthType) -> Color {
        type == .current ? currentMonthUnSelectedColor: unSelectedColor
    }
    
    private var monthStruct: MonthStruct {
        let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
        if count <= start {
            let day = daysInPrevMonth + count - start
            return MonthStruct(monthType: .previous, dayInt: day)
        } else if count - start > daysInMonth {
            let day = count - start - daysInMonth
            return MonthStruct(monthType: .next, dayInt: day)
        }
        
        let day = count - start
        return MonthStruct(monthType: .current, dayInt: day)
    }
}

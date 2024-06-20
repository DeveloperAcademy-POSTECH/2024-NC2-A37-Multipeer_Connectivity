//
//  DateManager.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/18/24.
//

import Foundation

@Observable
class DateManager {
    var selectedTimes: [SelectedTime] = []
    
    var receivedScheduleData: [[String : Any]] = []
    
    var finalSchedule: [[SelectedTime]] = []
    
    var weeks: [Week] = []
    
    var currentWeekIndex: Int = 0
    
    var currentMonth: Int {
        weeks[currentWeekIndex].month
    }
    
    var currentWeekStart: Date {
        calendar.date(byAdding: .hour, value: 9, to: weeks[currentWeekIndex].weekStart)!
    }
    
    var currentWeekOfMonth: Int {
        weeks[currentWeekIndex].weekOfMonth
    }
    
    var daySymbols: [String] {
        let symbols = calendar.shortWeekdaySymbols
        return Array(symbols[calendar.firstWeekday-1..<symbols.count] + symbols[0..<calendar.firstWeekday-1])
    }
    
    let calendar = Calendar.current
    
    static let daySymbolsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh시 mm분"
        return formatter
    }()
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }()
    static let detailDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y년 M월 d일"
        return formatter
    }()
    
    init() {
        generateWeeks()
    }
}

extension DateManager {
    func generateWeeks() -> Void {
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
        for weekIndex in 0..<100 { // 100주간 데이터 생성
            var week: [Date] = []
            for dayIndex in 0..<7 {
                let date = calendar.date(byAdding: .day, value: (weekIndex * 7) + dayIndex, to: startOfWeek)!
                week.append(date)
            }
            let weekStart = week.first!
            let components = calendar.dateComponents([.year, .month, .weekOfMonth], from: weekStart)
            let year = components.year!
            let month = components.month!
            let weekOfMonth = components.weekOfMonth!
            weeks.append(Week(weekStart: weekStart, dates: week, year: year, month: month, weekOfMonth: weekOfMonth))
        }
    }
}

//
//  WeeklyCalendar.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/15/24.
//

import SwiftUI

struct WeeklyCalendar: View {
    @State var dateManager: DateManager
    
    var body: some View {
        VStack {
            HStack {
                ForEach(dateManager.daySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 56)
            
            TabView(selection: $dateManager.currentWeekIndex) {
                ForEach(Array(dateManager.weeks.enumerated()), id: \.element.weekStart) { index, week in
                    HStack {
                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 0, bottomLeading: 0, bottomTrailing: 30, topTrailing: 30))
                            .frame(width: 14)
                            .foregroundStyle(.white)
                            .padding([.vertical, .trailing], 7.5)
                        HStack {
                            ForEach(week.dates, id: \.self) { date in
                                let day = dateManager.daySymbolsFormatter.string(from: date)
                                Text(day)
                                    .font(.system(size: 20))
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .padding(.horizontal)
                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 30, bottomLeading: 30, bottomTrailing: 0, topTrailing: 0))
                            .frame(width: 14)
                            .foregroundStyle(.white)
                            .padding([.vertical, .leading], 7.5)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 50)
        }
        .padding(.horizontal)
    }
}

struct WeeklyCalendar_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyCalendar(dateManager: DateManager())
    }
}

//import SwiftUI
//
//struct WeeklyCalendar: View {
//    private let calendar = Calendar.current
//    private let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d"
//        return formatter
//    }()
//    
//    private var daySymbols: [String] {
//        let symbols = calendar.shortWeekdaySymbols
//        return Array(symbols[calendar.firstWeekday-1..<symbols.count] + symbols[0..<calendar.firstWeekday-1])
//    }
//    
//    var body: some View {
//        VStack {
//            HStack {
//                ForEach(daySymbols, id: \.self) { symbol in
//                    Text(symbol)
//                        .font(.caption2)
//                        .foregroundStyle(.gray)
//                        .frame(maxWidth: .infinity)
//                }
//            }
//            .padding(.horizontal, 56)
//            
//            ScrollView(.horizontal, showsIndicators: false) {
//                LazyHStack(spacing: 0) {
//                    Spacer().frame(width: 36)
//                    ForEach(generateWeeks(), id: \.weekStart) { week in
//                        HStack(spacing: 10) {
//                            ForEach(week.dates, id: \.self) { date in
//                                let day = dateFormatter.string(from: date)
//                                Text(day)
//                                    .font(.system(size: 20))
//                                    .frame(minWidth: 26)
//                            }
//                        }
//                        .padding(.horizontal)
//                        .padding(.vertical, 8)
//                        .background(.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 30))
//                        .padding(.horizontal, 8)
//                        
//                        RoundedRectangle(cornerRadius: 30)
//                            .frame(width: 28)
//                            .padding(7.5)
//                            .padding(.horizontal, 14)
//                            .foregroundStyle(.white)
//                    }
//                }
//                .frame(height: 50)
//            }
//            .scrollTargetBehavior(.paging)
//        }
//        .padding(.horizontal, 16)
//    }
//}
//
//extension WeeklyCalendar {
//    private struct Week: Identifiable {
//        let id = UUID()
//        let weekStart: Date
//        let dates: [Date]
//        let year: Int
//        let month: Int
//        let weekOfMonth: Int
//    }
//    
//    private func generateWeeks() -> [Week] {
//        var weeks: [Week] = []
//        let today = Date()
//        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
//        
//        for weekIndex in 0..<100 { // 100주간 데이터 생성
//            var week: [Date] = []
//            for dayIndex in 0..<7 {
//                let date = calendar.date(byAdding: .day, value: (weekIndex * 7) + dayIndex, to: startOfWeek)!
//                week.append(date)
//            }
//            let weekStart = week.first!
//            let components = calendar.dateComponents([.year, .month, .weekOfMonth], from: weekStart)
//            let year = components.year!
//            let month = components.month!
//            let weekOfMonth = components.weekOfMonth!
//            weeks.append(Week(weekStart: weekStart, dates: week, year: year, month: month, weekOfMonth: weekOfMonth))
//        }
//        return weeks
//    }
//}
//
//struct WeeklyCalendar_Previews: PreviewProvider {
//    static var previews: some View {
//        WeeklyCalendar()
//    }
//}

//import SwiftUI
//
//struct WeeklyCalendar: View {
//    private let calendar = Calendar.current
//    private let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d"
//        return formatter
//    }()
//    
//    private var daySymbols: [String] {
//        let symbols = calendar.shortWeekdaySymbols
//        return Array(symbols[calendar.firstWeekday-1..<symbols.count] + symbols[0..<calendar.firstWeekday-1])
//    }
//    
//    var body: some View {
//        VStack {
//            HStack {
//                ForEach(daySymbols, id: \.self) { symbol in
//                    Text(symbol)
//                        .font(.caption2)
//                        .foregroundStyle(.gray)
//                        .frame(maxWidth: .infinity)
//                }
//            }
//            .padding(.horizontal, 48)
//            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack {
//                    Spacer().frame(width: 14)
//                    LazyHStack(spacing: 0) {
//                        ForEach(generateWeeks(), id: \.weekStart) { week in
//                            Spacer().frame(width: 14)
//                            HStack(spacing: 10) {
//                                ForEach(week.dates, id: \.self) { date in
//                                    let day = dateFormatter.string(from: date)
//                                    Text(day)
//                                        .font(.system(size: 20))
//                                        .frame(minWidth: 26)
//                                }
//                            }
//                            .padding(.horizontal)
//                            .padding(.vertical, 8)
//                            .background(.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 30))
//                            .padding(.horizontal, 8)
//                        }
//                    }
//                    .scrollTargetLayout()
//                    .frame(height: 50)
//                }
//            }
//            .scrollTargetBehavior(CustomScrollTargetBehavior())
//        }
//        .padding(.horizontal, 8)
//    }
//}
//
//extension WeeklyCalendar {
//    private struct Week: Identifiable {
//        let id: UUID = UUID()
//        let weekStart: Date
//        let dates: [Date]
//        let year: Int
//        let month: Int
//        let weekOfMonth: Int
//    }
//    
//    private func generateWeeks() -> [Week] {
//        var weeks: [Week] = []
//        let today = Date()
//        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
//        
//        for weekIndex in 0..<100 { // 100주간 데이터 생성
//            var week: [Date] = []
//            for dayIndex in 0..<7 {
//                let date = calendar.date(byAdding: .day, value: (weekIndex * 7) + dayIndex, to: startOfWeek)!
//                week.append(date)
//            }
//            let weekStart = week.first!
//            let components = calendar.dateComponents([.year, .month, .weekOfMonth], from: weekStart)
//            let year = components.year!
//            let month = components.month!
//            let weekOfMonth = components.weekOfMonth!
//            weeks.append(Week(weekStart: weekStart, dates: week, year: year, month: month, weekOfMonth: weekOfMonth))
//        }
//        return weeks
//    }
//}
//
//struct WeeklyCalendar_Previews: PreviewProvider {
//    static var previews: some View {
//        WeeklyCalendar()
//    }
//}
//struct CustomScrollTargetBehavior: ScrollTargetBehavior {
//    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
//        if context.velocity.dx > 0 {
//            target.rect.origin.x = context.originalTarget.rect.maxX
//        } else if context.velocity.dx < 0 {
//            target.rect.origin.x = context.originalTarget.rect.minX
//        }
//    }
//}

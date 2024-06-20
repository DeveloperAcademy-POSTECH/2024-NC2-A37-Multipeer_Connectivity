//
//  MainView.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/15/24.
//

import SwiftUI

struct MainView: View {
    var dateManager: DateManager = DateManager()
    var timeDotManager: TimeDotManager = TimeDotManager()
    
    @State private var currentMonth: Int = 0
    @State private var currentWeekOfMonth: Int = 0
    @State private var currentWeekStart: Date = Date()
   
    @State private var selectedTimes: [SelectedTime] = []
    
    var body: some View {
        ZStack(alignment: .leading) {
            AppColor.background
            NavigationView {
                VStack(spacing: 0) {
                    MainViewTitle(month: dateManager.currentMonth)
                    Spacer().frame(height: 32)
                    WeeklyCalendar(dateManager: dateManager)
                    TimeBlock(timeDotManager: timeDotManager, dateManager: dateManager)
                    Spacer().frame(height: 20)
                    ConfirmScheduleButton(
                        currentMonth: $currentMonth,
                        currentWeekOfMonth: $currentWeekOfMonth,
                        selectedTimes: $selectedTimes,
                        currentWeekStart: $currentWeekStart,
                        dateManager: dateManager,
                        timeDotManager: timeDotManager
                    )
                }
            }
            .ignoresSafeArea()
        }
    }
}

private func MainViewTitle(month: Int) -> some View {
    HStack {
        Text("\(month)월")
            .font(.title2)
            .foregroundStyle(AppColor.mint)
            .bold()
        Text("약쓱 가능 시간")
            .font(.title2)
            .bold()
    }
}

struct ConfirmScheduleButton: View {
    @Binding var currentMonth: Int
    @Binding var currentWeekOfMonth: Int
    @Binding var selectedTimes: [SelectedTime]
    @Binding var currentWeekStart: Date
    
    var dateManager: DateManager
    var timeDotManager: TimeDotManager
    
    var body: some View {
        VStack {
            NavigationLink {
                ShareScheduleView(currentMonth: $currentMonth,
                                  currentWeekOfMonth: $currentWeekOfMonth,
                                  selectedTimes: $selectedTimes,
                                  currentWeekStart: $currentWeekStart,
                                  dateManager: dateManager,
                                  timeDotManager: timeDotManager)
            } label: {
                Label {
                    Text("내 스케줄 완성하기")
                } icon: {
                    Image("ConfirmSchedule")
                }
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.black)
                )
            }
        }
    }
}

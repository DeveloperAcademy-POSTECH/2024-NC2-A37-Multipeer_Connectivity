//
//  MainView.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/15/24.
//

import SwiftUI

struct MainView: View {
    var dateManager: DateManager
    var timeDotManager: TimeDotManager
    
    @State private var selectedTimes: [SelectedTime] = []
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                AppColor.background
                VStack(spacing: 0) {
                    MainViewTitle(month: dateManager.currentMonth)
                    Spacer().frame(height: 32)
                    WeeklyCalendar(dateManager: dateManager)
                    TimeBlock(timeDotManager: timeDotManager, dateManager: dateManager)
                    Spacer().frame(height: 20)
                    ConfirmScheduleButton(
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
    var dateManager: DateManager
    var timeDotManager: TimeDotManager
    
    var body: some View {
        VStack {
            NavigationLink {
                ShareScheduleView(
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

#Preview {
    MainView(dateManager: DateManager(), timeDotManager: TimeDotManager())
}

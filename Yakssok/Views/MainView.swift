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
    
    var body: some View {
        ZStack(alignment: .leading) {
            AppColor.background
            VStack(spacing: 0) {
                MainViewTitle(month: dateManager.currentMonth)
                
                Spacer().frame(height: 32)
                
                WeeklyCalendar(dateManager: dateManager)
                
                TimeBlock(timeDotManager: timeDotManager, dateManager: dateManager)
                
                Spacer().frame(height: 20)
                
                ConfirmScheduleButton(dateManager: dateManager, timeDotManager: timeDotManager)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MainView()
}

@ViewBuilder
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

@ViewBuilder
private func ConfirmScheduleButton(dateManager: DateManager, timeDotManager: TimeDotManager) -> some View {
    Button {
        // TODO: 공유 뷰로 네비게이트
        // 선택 시간 디버깅
        print("\(dateManager.currentMonth)월 \(dateManager.currentWeekOfMonth)주차")
        let selectedTimes = timeDotManager.calcSelectedTime(dateManager: dateManager)
        for time in selectedTimes {
            print("Date: \(time.day), Start: \(dateManager.timeFormatter.string(from: time.startTime)), End: \(dateManager.timeFormatter.string(from: time.endTime)), Duration: \(time.duration)")
        }
    } label: {
        Label {
            Text("내 스케줄 완성하기")
        } icon: {
            Image("ConfirmSchedule")
        }
        .foregroundStyle(.white)
        .padding()
        .padding(.horizontal, 30)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.black)
        )
    }
}

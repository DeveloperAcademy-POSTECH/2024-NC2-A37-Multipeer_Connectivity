//
//  CompleteScheduleView.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/19/24.
//

import SwiftUI

struct CompleteScheduleView: View {
    var dateManager: DateManager
    var timeDotManager: TimeDotManager
    
    var body: some View {
        ZStack {
            AppColor.background
            VStack(spacing: 10) {
                CompleteScheduleViewTitle()
                
                Spacer().frame(height: 2)
                
                SelectAllButtonRow()
                
                Divider()
                
                UserFilterButtonRow()
                
                Spacer().frame(height: 12)
                
                WeekRow()
                
                CompleteScheduleTimeBlock(timeDotManager: TimeDotManager(), dateManager: DateManager())
            }
        }
        .ignoresSafeArea()
    }
}

let tempData: [ScheduleData] = [
    .init(name: "Sadie", selectedWeekStart: Calendar.current.date(byAdding: .day, value: -3, to: .now)!, selectedTimes: [
        .init(day: 21, startTime: Calendar.current.date(byAdding: .hour, value: 3, to: Calendar.current.date(byAdding: .day, value: 1, to: .now)!)!, endTime: Calendar.current.date(byAdding: .hour, value: 6, to: Calendar.current.date(byAdding: .day, value: 1, to: .now)!)!),
        .init(day: 22, startTime: Calendar.current.date(byAdding: .hour, value: 5, to: Calendar.current.date(byAdding: .day, value: 2, to: .now)!)!, endTime: Calendar.current.date(byAdding: .hour, value: 7, to: Calendar.current.date(byAdding: .day, value: 2, to: .now)!)!)
    ]),
    .init(name: "Chan", selectedWeekStart: Calendar.current.date(byAdding: .day, value: -3, to: .now)!, selectedTimes: [
        .init(day: 22, startTime: Calendar.current.date(byAdding: .hour, value: 3, to: Calendar.current.date(byAdding: .day, value: 2, to: .now)!)!, endTime: Calendar.current.date(byAdding: .hour, value: 6, to: Calendar.current.date(byAdding: .day, value: 2, to: .now)!)!),
        .init(day: 23, startTime: Calendar.current.date(byAdding: .hour, value: 2, to: Calendar.current.date(byAdding: .day, value: 3, to: .now)!)!, endTime: Calendar.current.date(byAdding: .hour, value: 7, to: Calendar.current.date(byAdding: .day, value: 3, to: .now)!)!)
    ])
]

@ViewBuilder
private func CompleteScheduleViewTitle() -> some View {
    HStack {
        Text("전체 스케줄")
            .font(.title2)
            .bold()
    }
}

@ViewBuilder
private func SelectAllButtonRow() -> some View {
    HStack {
        Spacer()
        Toggle(isOn: .constant(true)) {
            Text("전체 선택")
                .foregroundStyle(.gray)
                .font(.caption2)
        }
        .toggleStyle(CheckboxToggleStyle())
    }
    .padding(.horizontal)
}

@ViewBuilder
private func UserFilterButtonRow() -> some View {
    ScrollView(.horizontal) {
        HStack(spacing: 0) {
            ForEach(tempData, id: \.self) { data in
                UserFilterButton(data.name)
            }
        }
    }
    .padding(.horizontal)
}

@ViewBuilder
private func UserFilterButton(_ userName: String) -> some View {
    Button {
        // TODO: 필터 액션
    } label: {
        Text(userName)
            .foregroundStyle(AppColor.white)
            .frame(width: 90, height: 35)
            .background(
                RoundedRectangle(cornerRadius: 90)
                    .foregroundStyle(.black)
            )
            .padding(6)
    }
    .shadow(radius: 2, x: 2, y: 2)
}

@ViewBuilder
private func WeekRow() -> some View {
    VStack {
        HStack {
            Text("일")
                .font(.caption2)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity)
            Text("월")
                .font(.caption2)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity)
            Text("화")
                .font(.caption2)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity)
            Text("수")
                .font(.caption2)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity)
            Text("목")
                .font(.caption2)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity)
            Text("금")
                .font(.caption2)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity)
            Text("토")
                .font(.caption2)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 56)
        HStack {
            ForEach(Array(0...6), id: \.self) { index in
                let date = Calendar.current.date(byAdding: .day, value: index, to: tempData[0].selectedWeekStart)!
                let day = Calendar.current.dateComponents([.day], from: date).day!.description
                Text(day)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.horizontal, 40)
        .shadow(radius: 2, x: 1, y:1)
    }
    .padding(.horizontal)
}

#Preview {
    CompleteScheduleView(dateManager: DateManager(), timeDotManager: TimeDotManager())
}

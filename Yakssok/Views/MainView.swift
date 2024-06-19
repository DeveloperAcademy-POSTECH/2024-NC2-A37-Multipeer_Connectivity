//
//  MainView.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/15/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            AppColor.background
            VStack(spacing: 0) {
                MainViewTitle
                
                Spacer().frame(height: 32)
                
                WeeklyCalendar()
                
                TimeBlock()
                
                Spacer().frame(height: 20)
                
                ConfirmScheduleButton
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MainView()
}

private var MainViewTitle: some View {
    HStack {
        Text("6월")
            .font(.title2)
            .foregroundStyle(AppColor.mint)
            .bold()
        Text("약쓱 가능 시간")
            .font(.title2)
            .bold()
    }
}

private var ConfirmScheduleButton: some View {
    Button {
        // TODO: 공유 뷰로 네비게이트
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

//
//  SuccessCompleteScheduleView.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/20/24.
//

import SwiftUI

struct SuccessCompleteScheduleView: View {
    var body: some View {
        ZStack {
            AppColor.darkgray
            VStack {
                // TODO: - 이미지
                SuccessCompleteScheduleCard()
            }
        }
        .ignoresSafeArea()
    }
}

@ViewBuilder
private func SuccessCompleteScheduleCard() -> some View {
    VStack {
        HStack {
            Text("약쓱이\n확정되었어요 !")
                .font(.title)
                .bold()
            Spacer()
            HStack {
                Text("Sadie")
                Text("Chan")
            }
            .font(.callout)
            .foregroundStyle(.gray)
        }
        HStack {
            HStack {
                Text("23")
                    .font(.largeTitle)
                    .bold()
                Text("금요일")
                    .bold()
            }
            .frame(width: 126, height: 58)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColor.background))

            Spacer()
        }
        HStack {
            VStack(alignment: .leading) {
                Text("오후 6:00")
                    .bold()
                Text("시작")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
            Spacer()
            Text("5시간")
                .font(.caption)
                .foregroundStyle(AppColor.orange)
                .frame(width: 94,height: 16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColor.orange.opacity(0.1)))
            Spacer()
            VStack(alignment: .leading) {
                Text("오후 11:00")
                    .bold()
                Text("종료")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
        }
    }
    .padding(30)
    .background(
        RoundedRectangle(cornerRadius: 30)
            .fill(AppColor.white))
    .padding(20)
}

#Preview {
    SuccessCompleteScheduleView()
}

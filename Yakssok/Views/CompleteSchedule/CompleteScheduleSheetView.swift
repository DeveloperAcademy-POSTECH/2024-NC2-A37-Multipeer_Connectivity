//
//  CompleteScheduleSheetView.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/20/24.
//

import SwiftUI

struct CompleteScheduleSheetView: View {
    @Binding var isPresented: Bool
    @State private var schedule: SelectedTime = .init(day: 20, startTime: .now, endTime: Calendar.current.date(byAdding: .hour, value: 3, to: .now)!)
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width:50, height:5)
                .foregroundColor(AppColor.darkgray)
                .cornerRadius(15)
            
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("취소")
                        .foregroundColor(AppColor.orange)
                        .padding()
                }
                Spacer()
            }
            
            Text("시간 확정하기")
                .font(.title3)
                .fontWeight(.bold)
            
            Divider()
            
            HStack {
                Text("\(schedule.day)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(AppColor.white)
                    .frame(width: 70, height: 70)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.black)
                    )
                    .padding()
                Spacer().frame(width: 20)
                VStack {
                    DatePicker(selection: $schedule.startTime, displayedComponents: .hourAndMinute) {
                        Text("시작 시간")
                            .font(.subheadline)
                            .bold()
                    }
                    Divider()
                    DatePicker(selection: $schedule.endTime, displayedComponents: .hourAndMinute) {
                        Text("종료 시간")
                            .font(.subheadline)
                            .bold()
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            
            Spacer()
            
            Button{
                isPresented = false
                // TODO: - 약쓱 확정 카드 띄우기
            } label: {
                Text("약속 시간 확정하기")
                    .font(.subheadline)
                    .frame(width: 300, height: 40)
                    .background(AppColor.black)
                    .foregroundColor(AppColor.white)
                    .cornerRadius(90)
            }
            
        }
        .padding()
    }
}

#Preview {
    CompleteScheduleSheetView(isPresented: .constant(true))
}

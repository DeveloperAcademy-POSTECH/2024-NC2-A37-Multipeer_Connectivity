//
//  Test.swift
//  Yakssok
//
//  Created by 추서연 on 6/20/24.
//

import SwiftUI

struct Test: View {
    @Binding var currentMonth: Int
    @Binding var currentWeekOfMonth: Int
    @Binding var selectedTimes: [SelectedTime]
    
    var dateManager: DateManager = DateManager()
    var timeDotManager: TimeDotManager = TimeDotManager()
    
    var body: some View {
        VStack(alignment: .leading){
            
            Text("나의 약속 가능 스케줄")
                .font(.title3)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            VStack(alignment:.leading){
                Text("\(dateManager.currentMonth)월 \(dateManager.currentWeekOfMonth)주차")
                    .font(.caption)
                    .foregroundColor(AppColor.darkgray)
                
                let selectedTimes = timeDotManager.calcSelectedTime(dateManager: dateManager)
                
                ForEach(selectedTimes, id: \.day) { time in
                    HStack(alignment: .center, spacing: 5) {
                        Text("\(time.day)")
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.horizontal,5)
                        
                        Text("\(dateManager.timeFormatter.string(from: time.startTime).dropLast(3))")
                            .font(.subheadline)
                        
                        Text("~ \(dateManager.timeFormatter.string(from: time.endTime).dropLast(3))")
                            .font(.subheadline)
                        
                        Text("\(time.duration) 시간")
                            .font(.caption)
                            .frame(width: 80, height: 16)
                            .background(AppColor.orange.opacity(0.2))
                            .cornerRadius(90)
                            .foregroundColor(AppColor.orange)
                            .padding(.horizontal,5)
                    }
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                
            }.frame(width:330)
                .padding(15)
                .background(AppColor.white)
                .cornerRadius(30)
        }
    }
   
}


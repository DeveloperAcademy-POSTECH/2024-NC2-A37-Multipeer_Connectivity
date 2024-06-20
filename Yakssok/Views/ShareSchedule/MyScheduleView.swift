//
//  MyScheduleView.swift
//  Yakssok
//
//  Created by 추서연 on 6/17/24.
//

import SwiftUI

struct MyScheduleView: View {
    var dateManager: DateManager
    var timeDotManager: TimeDotManager
    
    var body: some View {
        VStack(alignment: .leading){
            
            Text("나의 약속 가능 스케줄")
                .font(.title3)
                .fontWeight(.bold)
            
            VStack(alignment:.leading) {
                Text("\(dateManager.currentMonth)월 \(dateManager.currentWeekOfMonth)주차")
                    .font(.caption)
                    .foregroundColor(AppColor.darkgray)
               
                ForEach(dateManager.selectedTimes, id: \.day) { time in
                    HStack(alignment: .center, spacing: 5) {
                        Text("\(time.day)")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal, 5)
                            .frame(width: 50)
                        
                        HStack {
                            Text(String(DateManager.timeFormatter.string(from: time.startTime).dropLast(3)))
                                .font(.subheadline)
                            
                            Text("~ ")
                                .font(.subheadline)
                            
                            Text(String(DateManager.timeFormatter.string(from: time.endTime).dropLast(3)))
                                .font(.subheadline)
                        }
                        .frame(width: 166)
                        
                        Text("\(time.duration) 시간")
                            .font(.caption)
                            .frame(width: 76, height: 16)
                            .background(AppColor.orange.opacity(0.2))
                            .cornerRadius(90)
                            .foregroundColor(AppColor.orange)
                            .padding(.horizontal,5)
                    }
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .frame(width:330)
            .padding(20)
            .background(AppColor.white)
            .cornerRadius(30)
            .onAppear {
                dateManager.selectedTimes = timeDotManager.calcSelectedTime(dateManager: dateManager)
            }
                
        }
    }
   
}


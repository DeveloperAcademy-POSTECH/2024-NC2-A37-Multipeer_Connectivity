//
//  MyScheduleView.swift
//  Yakssok
//
//  Created by 추서연 on 6/17/24.
//

import SwiftUI

struct ScheduleView: View {
    var body: some View {
        NavigationView {
        ZStack{
            AppColor.background.edgesIgnoringSafeArea(.all)
            
                
                
                VStack(spacing:15){
                    Text("약쓱 가능 시간")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(15)
                    
                    DotLabel()
                    WeeklyCalendar()
                    
                    HStack{
                        TimeTitle()
                        TimeBlock()
                    }.padding(15)
                    
                    Button(action: {
                        //
                    }) {
                        NavigationLink(destination: ShareScheduleView()) {
                            HStack {
                                Text("아이콘")
                                Text("내 스케줄 완성하기")
                            }
                            .frame(width: 300, height: 40)
                            .background(AppColor.black)
                            .foregroundColor(AppColor.white)
                            .cornerRadius(90)
                        }
                    }
                }
            }
        }
    }
}



#Preview {
    ScheduleView()
}

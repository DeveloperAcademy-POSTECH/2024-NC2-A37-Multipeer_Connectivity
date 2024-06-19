//
//  MyScheduleView.swift
//  Yakssok
//
//  Created by 추서연 on 6/17/24.
//

import SwiftUI

struct MyScheduleView: View {
    var body: some View {
        VStack(alignment: .leading){
           
            Text("나의 약속 가능 스케줄")
                .font(.title3)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            VStack(alignment:.leading){
                Text("6월 셋째주")
                    .font(.caption)
                    .foregroundColor(AppColor.darkgray)
                HStack{
                    Text("23")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal,5)
                    
                    Text("오후 6시 ~ 오후 11시")
                        .font(.subheadline)
                    
                    Text("5시간")
                        .font(.caption)
                        .frame(width: 80, height: 16)
                        .background(AppColor.orange.opacity(0.2))
                        .cornerRadius(90)
                        .foregroundColor(AppColor.orange)
                        .padding(.horizontal,5)
                }
                HStack{
                    Text("23")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal,5)
                    
                    Text("오후 6시 ~ 오후 11시")
                        .font(.subheadline)
                    
                    Text("5시간")
                        .font(.caption)
                        .frame(width: 80, height: 16)
                        .background(AppColor.orange.opacity(0.2))
                        .cornerRadius(90)
                        .foregroundColor(AppColor.orange)
                        .padding(.horizontal,5)  
                }
            }.frame(width:330)
                .padding(15)
                .background(AppColor.white)
                .cornerRadius(30)
            
            
        }
    }
}

#Preview {
    MyScheduleView()
}

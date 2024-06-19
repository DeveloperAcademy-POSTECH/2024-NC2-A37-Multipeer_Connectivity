//
//  DotLabel.swift
//  Yakssok
//
//  Created by 추서연 on 6/17/24.
//
import SwiftUI

struct DotLabel: View {
    var body: some View {
        
        HStack{
            Spacer()
            Circle()
                .frame(width: 7)
                .foregroundColor(AppColor.darkgray)
            Text("일정 있어요")
                .font(.caption)
                .foregroundColor(AppColor.darkgray)
            Circle()
                .frame(width: 7)
                .foregroundColor(AppColor.mint)
            Text("가능해요")
                .font(.caption)
                .foregroundColor(AppColor.darkgray)
        }.padding(.horizontal,15)
        
        
    }
}

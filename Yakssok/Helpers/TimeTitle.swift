//
//  TimeTitle.swift
//  Yakssok
//
//  Created by 추서연 on 6/17/24.
//

import SwiftUI

struct TimeTitle: View {
    var body: some View {
        
        ZStack{
            VStack(spacing:5){
                Text("9am")
                Text("10am")
                Text("11am")
                Text("12pm")
                Text("1pm")
                Text("2pm")
                Text("3pm")
                Text("4pm")
                Text("5pm")
                Text("6pm")
                Text("7pm")
                Text("8pm")
                Text("9pm")
                Text("10pm")
                Text("11pm")
                Text("12am")
               
            }.padding(5)
                .font(.caption)
                .foregroundColor(AppColor.darkgray)
        }
    }
}



#Preview {
    TimeTitle()
}

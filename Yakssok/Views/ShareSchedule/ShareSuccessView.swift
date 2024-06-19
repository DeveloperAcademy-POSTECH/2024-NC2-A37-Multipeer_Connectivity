//
//  ShareSuccessView.swift
//  Yakssok
//
//  Created by 추서연 on 6/19/24.
//

import SwiftUI

struct ShareSuccessView: View {
    var body: some View {
        ZStack{
            AppColor.darkgray.edgesIgnoringSafeArea(.all)
            ZStack{
                VStack{
                    
                    Rectangle()
                        .cornerRadius(30)
                        .foregroundColor(AppColor.white)
                        .frame(width: 330, height: 360)
                        .overlay {
                            VStack(alignment: .leading) {
                                HStack {
                                    Spacer()
                                    NavigationLink(destination: ScheduleView()) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.black)
                                            .font(.system(size: 24))
                                            .padding()
                                    }
                                }
                                Spacer()
                                Text("성공적으로")
                                    .font(.title3)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .padding(.leading, 20)
                                Text("공유 되었습니다!")
                                    .font(.title3)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .padding(.leading, 20)
                                Spacer()
                            }
                        }
                    
                }
            }
        }
    }
}

#Preview {
    ShareSuccessView()
}

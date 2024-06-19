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
                        .overlay{
                            VStack(alignment:.leading){
                                Text("성공적으로")
                                Text("공유 되었습니다 !")
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

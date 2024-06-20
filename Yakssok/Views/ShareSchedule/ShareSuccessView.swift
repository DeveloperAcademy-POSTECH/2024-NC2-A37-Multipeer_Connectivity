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
                               
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        
                                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                            if let window = windowScene.windows.first {
                                                window.rootViewController?.dismiss(animated: true, completion: nil)
                                            }
                                            
                                        }
                                    }) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(AppColor.darkgray)
                                            .padding()
                                            .font(.title)
                                        
                                    }
                                }
                                    //.padding(.top, 50)
                                HStack{
                                    Spacer()
                                    Image("profile2")
                                        .resizable()
                                        .frame(width:150, height: 150)
                                    Spacer()
                                }
                                Spacer()
                                Text("성공적으로")
                                    .font(.title3)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .padding(.leading, 40)
                                Text("공유 되었습니다!")
                                    .font(.title3)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .padding(.leading, 40)
                                
                                
                                Text("약속 리더의 스케줄 확정을 기다려주세요")
                                    .padding(.top,2)
                                    .padding(.leading, 40)
                                    
                                    //.padding(10)
                                    .font(.caption)
                                    .foregroundColor(AppColor.darkgray)
                                    
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

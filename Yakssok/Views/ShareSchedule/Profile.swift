//
//  Profile.swift
//  Yakssok
//
//  Created by 추서연 on 6/17/24.
//
import SwiftUI
import MultipeerConnectivity

struct Profile: View {
    @Binding var displayName: String
    @ObservedObject var connectivityManager: MultipeerConnectivityManager
    
    var body: some View {
        
        HStack{
            Circle()
                .frame(width: 90)
                .foregroundColor(AppColor.white)
                .shadow(radius: 1)
                .overlay{
                    Image("profile1")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(90)
                }

            VStack (alignment:.leading){
                Text("다음과 같이 표시")
                    .font(.caption)
                    .foregroundColor(AppColor.darkgray)
                    .padding(.top, 20)
                HStack{
                    TextField("Enter your name", text: $displayName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 150, height: 40)
           
                    Button(action: {
                        connectivityManager.updatePeerID(name: displayName)
                    }) {
                        Text("저장")
                            .padding()
                            .font(.subheadline)
                            .frame(width: 60, height: 30)
                            .background(AppColor.black)
                            .foregroundColor(AppColor.white)
                            .cornerRadius(30)
                    }
                    
                }.padding(.bottom)
                    
            }.padding(15)
            
            
        }
    }
}

#Preview {
    Profile(
            displayName: .constant("Preview Name"),
            connectivityManager: MultipeerConnectivityManager()
        )
    
}

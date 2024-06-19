//
//  ShareFriendView.swift
//  Yakssok
//
//  Created by 추서연 on 6/18/24.
//


import SwiftUI
import MultipeerConnectivity

struct PeerListView: View {
    @ObservedObject var connectivityManager: MultipeerConnectivityManager
    @Binding var selectedPeer: MCPeerID?
    @Binding var receivedPeers: [String]
    
    
    var body: some View {
        VStack(alignment: .leading){
            
            Text("공유 친구 선택")
                .font(.title3)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(connectivityManager.peers, id: \.self) { peer in
                        Button(action: {
                            self.selectedPeer = peer
                            self.connectivityManager.invite(peer: peer)
                        }) {
                            CircleView(label: peer.displayName, isSelected: peer == selectedPeer)
                                .foregroundColor(peer == selectedPeer ? AppColor.mint : .primary)
                            //.shadow(peer == selectedPeer ? .darkgray.opacity(0.3) : .red.opacity(0.3))
                            //.padding(.vertical, 5)
                            
                        }
                    }
                }.frame(height: 150)
            }
            
            if receivedPeers.isEmpty {
                HStack (alignment: .center) {
                    Image(systemName: "info.circle")
                    Text("약속 리더는 스케줄 공유를 기다려주세요")
                }
                .frame(width: 360, height: 60)
                .background(AppColor.white)
                .font(.caption)
                .foregroundColor(AppColor.darkgray)
                .shadow(color: AppColor.darkgray.opacity(0.3), radius: 10)
                .cornerRadius(15)
            } else {
                HStack (alignment: .center) {
                    SharedPeer(receivedPeers: $receivedPeers)
                        .shadow(color: AppColor.darkgray.opacity(0.2), radius: 10)
                }
                .frame(width: 360, height: 60)
                .background(Color.blue)
                .font(.caption)
                .cornerRadius(15)
            }
        }
        
        
        
        
        
    }
    
}

    
     
    




struct CircleView: View {
    @State var label: String
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Rectangle()
            .fill(AppColor.white)
            .frame(width: 80, height: 100)
            .cornerRadius(15)
            .shadow(color: AppColor.darkgray.opacity(0.3), radius: 10)
            .overlay(Text(label)
                .font(.caption))
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? AppColor.mint : AppColor.darkgray)
                                        .padding(5)
            /*Text(label)
                .overlay{
                    Rectangle()
                        .fill(AppColor.white)
                        .frame(width: 80, height: 100)
                        .cornerRadius(15)
                        .shadow(color: AppColor.darkgray.opacity(0.3), radius: 10)
                }*/
        }.padding(5)
    }
}
/*
#Preview {
    ShareFriendView()
}*/

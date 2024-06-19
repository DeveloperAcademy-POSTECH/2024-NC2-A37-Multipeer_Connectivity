//
//  ShareScheduleView.swift
//  Yakssok
//
//  Created by 추서연 on 6/17/24.
//

import SwiftUI
import MultipeerConnectivity

struct ShareScheduleView: View {
    @ObservedObject var connectivityManager: MultipeerConnectivityManager
    @State private var selectedPeer: MCPeerID?
    @State private var displayName = UIDevice.current.name
    @State private var messageToSend = ""
    @State private var receivedPeers: [String] = []
    
    init() {
            self.connectivityManager = MultipeerConnectivityManager()
        }
    
    var body: some View {
        
        ZStack{
            AppColor.background.edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack{
                    Text("내 스케줄")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(15)
                    
                    Profile(displayName: $displayName, connectivityManager: connectivityManager)
                        .padding(.bottom,30)
                    
                    MyScheduleView()
                        .padding(.bottom,30)
                    
                    PeerListView(connectivityManager: connectivityManager, selectedPeer: $selectedPeer, receivedPeers: $receivedPeers)
                    
                    ShareDetailView(selectedPeer: $selectedPeer, messageToSend: $messageToSend, receivedPeers: $receivedPeers, connectivityManager: connectivityManager)
                    
                    
                                    
                                    
                    
                }.padding(15)
            }
        }
    }
}

#Preview {
    ShareScheduleView()
}

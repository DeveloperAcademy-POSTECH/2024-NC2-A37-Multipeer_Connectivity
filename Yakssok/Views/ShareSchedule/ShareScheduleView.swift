//
//  ShareScheduleView.swift
//  Yakssok
//
//  Created by 추서연 on 6/17/24.
//


import SwiftUI
import MultipeerConnectivity

struct ShareScheduleView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var dateManager: DateManager
    var timeDotManager: TimeDotManager
    
    @ObservedObject var connectivityManager: MultipeerConnectivityManager = MultipeerConnectivityManager()
    
    @State private var selectedPeer: MCPeerID?
    @State private var displayName = UIDevice.current.name
    @State private var receivedPeers: [String] = []
    
    var body: some View {
        
        ZStack {
            AppColor.background.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    Text("내 스케줄")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer().frame(height: 15)
                    
                    Profile(displayName: $displayName, connectivityManager: connectivityManager)
                        .padding(.bottom,30)
                    
                    MyScheduleView(
                        dateManager: dateManager,
                        timeDotManager: timeDotManager)
                    .padding(.bottom,30)
                    
                    PeerListView(connectivityManager: connectivityManager, selectedPeer: $selectedPeer, receivedPeers: $receivedPeers)
                    
                    ShareDetailView(
                        connectivityManager: connectivityManager,
                        dateManager: dateManager,
                        timeDotManager: timeDotManager,
                        selectedPeer: $selectedPeer,
                        receivedPeers: $receivedPeers
                    )
                    
                    Spacer()
                }
                .onAppear {
                    let selectedTimes = timeDotManager.calcSelectedTime(dateManager: dateManager)
                    dateManager.selectedTimes = selectedTimes
                    dateManager.finalSchedule.append(selectedTimes)
                    
                    print("selectedTimes in ShareScheduleView: \(dateManager.selectedTimes)")
                }
                .padding(15)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(AppColor.darkgray)
                        }
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ShareScheduleView(dateManager: DateManager(), timeDotManager: TimeDotManager())
}

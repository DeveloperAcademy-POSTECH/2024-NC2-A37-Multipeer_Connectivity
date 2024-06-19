//
//  MultipeerView.swift
//  Yakssok
//
//  Created by 추서연 on 6/17/24.
//

import SwiftUI
import MultipeerConnectivity
struct MultipeerView: View {
    @ObservedObject var connectivityManager = MultipeerConnectivityManager()
    @State private var messageToSend = ""
    @State private var selectedPeer: MCPeerID?
    @State private var isShowingReceiveModal = false
    @State private var isShowingAlert = false
    @State private var peerToReceiveDataFrom: MCPeerID?
    @State private var peerToSendAlert: MCPeerID?
    @State private var displayName = UIDevice.current.name
    
    var body: some View {
        NavigationView {
            ZStack{
                AppColor.background.edgesIgnoringSafeArea(.all)
                
                    VStack {
                        Text("내 스케줄")
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(15)
                        
                        Profile(displayName: $displayName, connectivityManager: connectivityManager)
                            .padding(.bottom,30)
                        
                        MyScheduleView()
                            .padding(.bottom,30)
                        /*
                         TextField("Enter your name", text: $displayName)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                         .padding()
                         
                         Button(action: {
                         connectivityManager.updatePeerID(name: displayName)
                         }) {
                         Text("Save")
                         .padding()
                         .background(Color.blue)
                         .foregroundColor(.white)
                         .cornerRadius(8)
                         }
                         .padding(.bottom)
                         
                         */
                        
                        
                        
                        
                        TextField("Enter message", text: $messageToSend)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button(action: {
                         if let peer = self.selectedPeer {
                         if connectivityManager.isConnected(peer: peer) {
                         connectivityManager.send(text: messageToSend, to: peer)
                         messageToSend = ""
                         } else {
                         print("Peer \(peer.displayName) is not connected")
                         }
                         }
                         }) {
                         Text("Send Message")
                         .padding()
                         .background(Color.blue)
                         .foregroundColor(.white)
                         .cornerRadius(8)
                         }
                        
                    }
                    .onAppear {
                        connectivityManager.startBrowsing()
                        connectivityManager.receiveData { data, peerID in
                            // Handle received data
                            self.peerToSendAlert = peerID
                            self.isShowingAlert = true
                        }
                    }
                    .sheet(isPresented: $isShowingReceiveModal) {
                        if let receivedData = connectivityManager.receivedData {
                           // ReceivedDataView(receivedData: receivedData)
                        }
                    }.alert(isPresented: $isShowingAlert) {
                        let peerToSendAlert = self.peerToSendAlert
                        return Alert(
                            title: Text("Receive Data"),
                            message: Text("Do you want to receive data from \(peerToSendAlert?.displayName ?? "Unknown Peer")?"),
                            primaryButton:.default(Text("Yes")) {
                                self.isShowingReceiveModal = true
                            },
                            secondaryButton:.cancel(Text("No")) {
                                self.peerToSendAlert = nil
                            }
                        )
                    }
                    
                }
            }
        }
    }

//
//struct ReceivedDataView: View {
//    var receivedData: String
//    
//    var body: some View {
//        VStack {
//            Text("Received Data:")
//                .font(.headline)
//            Text(receivedData)
//                .padding()
//            
//            Spacer()
//        }
//        .padding()
//    }
//}

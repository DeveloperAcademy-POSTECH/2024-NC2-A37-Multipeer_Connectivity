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
    @State private var scheduleData: [[Any]] = []
    
    @Binding var currentMonth: Int
    @Binding var currentWeekOfMonth: Int
    @Binding var selectedTimes: [SelectedTime]
    @Binding var currentWeekStart: Date
    
    var dateManager: DateManager
    var timeDotManager: TimeDotManager
    
    
    @Environment(\.presentationMode) var presentationMode
    
    init(currentMonth: Binding<Int>, currentWeekOfMonth: Binding<Int>, selectedTimes: Binding<[SelectedTime]>, currentWeekStart: Binding<Date>, dateManager: DateManager, timeDotManager: TimeDotManager) {
           self._currentMonth = currentMonth
           self._currentWeekOfMonth = currentWeekOfMonth
           self._selectedTimes = selectedTimes
        self._currentWeekStart = currentWeekStart
           self.dateManager = dateManager
           self.timeDotManager = timeDotManager
           self.connectivityManager = MultipeerConnectivityManager()
       }
    
    var body: some View {
        
        ZStack{
            AppColor.background.edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack{
                    
                    
                    Text("내 스케줄")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(15)
                    
                    Profile(displayName: $displayName, connectivityManager: connectivityManager)
                        .padding(.bottom,30)
                    
                    MyScheduleView(currentMonth: $currentMonth,
                                   currentWeekOfMonth: $currentWeekOfMonth,
                                   selectedTimes: $selectedTimes,
                                   dateManager: dateManager,
                                   timeDotManager: timeDotManager)
                        .padding(.bottom,30)
                    
                    PeerListView(connectivityManager: connectivityManager, selectedPeer: $selectedPeer, receivedPeers: $receivedPeers)
                    
                    ShareDetailView(
                        selectedPeer: $selectedPeer,
                        messageToSend: $messageToSend,
                        receivedPeers: $receivedPeers,
                        scheduleData: $scheduleData,
                        currentWeekStart: $currentWeekStart,
                        connectivityManager: connectivityManager,
                        currentMonth: $currentMonth,
                        currentWeekOfMonth: $currentWeekOfMonth,
                        selectedTimes: $selectedTimes,
                        dateManager: dateManager,
                        timeDotManager: timeDotManager
                    )

                            
                }.onAppear {
                    // Initialize the date and times on appear
                    let dateManager = DateManager()
                    let timeDotManager = TimeDotManager()
                    
                    self.currentMonth = dateManager.currentMonth
                               self.currentWeekOfMonth = dateManager.currentWeekOfMonth
                               self.selectedTimes = timeDotManager.calcSelectedTime(dateManager: dateManager)
                               
                    print("selectedTimes in ShareScheduleView: \(selectedTimes)")
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



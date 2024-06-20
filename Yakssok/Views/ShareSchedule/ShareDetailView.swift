//
//  ShareDetailView.swift
//  Yakssok
//
//  Created by 추서연 on 6/18/24.
//
import SwiftUI
import MultipeerConnectivity


struct ShareDetailView: View {
    @Binding var selectedPeer: MCPeerID?
    @Binding var messageToSend : String
    @Binding var receivedPeers: [String]
    @Binding var scheduleData: [[Any]]
    @Binding var currentWeekStart: Date
    
    @State private var isShowingReceiveModal = false
    @State private var isShowingAlert = false
    @State private var peerToSendAlert: MCPeerID?
    @State private var showSuccessView = false
    
    @ObservedObject var connectivityManager: MultipeerConnectivityManager
    
    @Binding var currentMonth: Int
    @Binding var currentWeekOfMonth: Int
    @Binding var selectedTimes: [SelectedTime]
    
    var dateManager: DateManager = DateManager()
    var timeDotManager: TimeDotManager = TimeDotManager()
    
    var body: some View {
        
        VStack{
            
            Text(messageToSend)
                .opacity(0)
                .font(.caption2)
                .onAppear {
                    let text = "\(dateManager.currentMonth)- \(dateManager.currentWeekOfMonth)-\(currentWeekStart)" +
                    timeDotManager.calcSelectedTime(dateManager: dateManager)
                        .map { "/\(String(describing: $0.day))& \(dateManager.timeFormatter.string(from: $0.startTime))&\(dateManager.timeFormatter.string(from: $0.endTime))&\($0.duration)" }
                        .joined(separator: " - ")
                    messageToSend = text
                }
        }
        
        
        
        Button(action: {
            
            if let peer = self.selectedPeer {
                if connectivityManager.isConnected(peer: peer) {
                    connectivityManager.send(text: messageToSend, to: peer)
                    messageToSend = ""
                    
                    showSuccessView = true
                } else {
                    print("Peer \(peer.displayName) is not connected")
                }
            }
            
            
        }) {
            HStack{
                Image("ShareSchedule")
                Text("스케줄 공유하기")}
            .padding()
            .foregroundColor(AppColor.white)
            .padding(.horizontal, 30)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(AppColor.black)
            )
            
        }.fullScreenCover(isPresented: $showSuccessView) {
            ShareSuccessView()
        }
        .onAppear {
            connectivityManager.startBrowsing()
            connectivityManager.receiveData { data, peerID in
                self.peerToSendAlert = peerID
                self.isShowingAlert = true
            }
            
            print("selectedTimes in ShareDetailView: \(selectedTimes)")
        }
        .halfSheet(isPresented: $isShowingReceiveModal) {
            if let receivedData = connectivityManager.receivedData, let peer = self.peerToSendAlert {
                ReceiveScheduleView(receivedData: receivedData, peerDisplayName: peer.displayName, isPresented: $isShowingReceiveModal, receivedPeers: $receivedPeers,scheduleData: $scheduleData)
            }
            
        }
        .alert(isPresented: $isShowingAlert) {
            let peerToSendAlert = self.peerToSendAlert
            return Alert(
                title: Text("스케줄 공유"),
                message: Text("\(peerToSendAlert?.displayName ?? "Unknown Peer")에서 스케줄을 공유하려고 합니다"),
                primaryButton:.default(Text("수락")) {
                    self.isShowingReceiveModal = true
                },
                secondaryButton:.cancel(Text("거절")) {
                    self.peerToSendAlert = nil
                }
            )
        }
    }
}


struct HalfSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: SheetContent
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> SheetContent) {
        self._isPresented = isPresented
        self.sheetContent = content()
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                HalfSheetPresenter(isPresented: $isPresented, sheetContent: sheetContent)
            )
    }
}

private struct HalfSheetPresenter<SheetContent: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let sheetContent: SheetContent
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            let hostingController = UIHostingController(rootView: sheetContent)
            hostingController.modalPresentationStyle = .pageSheet
            uiViewController.present(hostingController, animated: true) {
                if let presentationController = hostingController.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.medium()]
                }
            }
        } else {
            uiViewController.dismiss(animated: true, completion: nil)
        }
    }
}

extension View {
    func halfSheet<SheetContent: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> SheetContent) -> some View {
        self.modifier(HalfSheet(isPresented: isPresented, content: content))
    }
}



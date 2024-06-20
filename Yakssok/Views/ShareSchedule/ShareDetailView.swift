//
//  ShareDetailView.swift
//  Yakssok
//
//  Created by 추서연 on 6/18/24.
//
import SwiftUI
import MultipeerConnectivity


struct ShareDetailView: View {
    @ObservedObject var connectivityManager: MultipeerConnectivityManager
    var dateManager: DateManager
    var timeDotManager: TimeDotManager
    
    @Binding var selectedPeer: MCPeerID?
    @Binding var receivedPeers: [String]
    
    @State private var isShowingReceiveModal = false
    @State private var isShowingAlert = false
    @State private var peerToSendAlert: MCPeerID?
    @State private var showSuccessView = false
    
    var body: some View {
        VStack {
            NavigationLink {
                CompleteScheduleView(dateManager: dateManager, timeDotManager: timeDotManager)
            } label: {
                HStack{
                    Image("ShareSchedule")
                    Text("스케줄 확정하기")
                }
                .padding()
                .foregroundColor(AppColor.white)
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(AppColor.black)
                )
            }


            Button {
                if let peer = self.selectedPeer {
                    if connectivityManager.isConnected(peer: peer) {
                        let text = "\(dateManager.currentMonth)-\(dateManager.currentWeekOfMonth)-\(DateManager.detailDateFormatter.string(from: dateManager.currentWeekStart))" +
                        timeDotManager.calcSelectedTime(dateManager: dateManager)
                            .map {
                                "/\(String(describing: $0.day))&\(DateManager.timeFormatter.string(from: $0.startTime))&\(DateManager.timeFormatter.string(from: $0.endTime))&\($0.duration)"
                            }
                            .joined(separator: "-")
                        
                        connectivityManager.send(text: text, to: peer)
                        
                        showSuccessView = true
                    } else {
                        print("Peer \(peer.displayName) is not connected")
                    }
                }
            } label: {
                HStack{
                    Image("ShareSchedule")
                    Text("스케줄 공유하기")
                }
                .padding()
                .foregroundColor(AppColor.white)
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(AppColor.black)
                )
                
            }
        }
        .fullScreenCover(isPresented: $showSuccessView) {
            ShareSuccessView()
        }
        .onAppear {
            connectivityManager.startBrowsing()
            connectivityManager.receiveData { data, peerID in
                self.peerToSendAlert = peerID
                self.isShowingAlert = true
            }
            
            print("selectedTimes in ShareDetailView: \(dateManager.selectedTimes)")
        }
        .sheet(isPresented: $isShowingReceiveModal) {
            if let receivedData = connectivityManager.receivedData, let peer = self.peerToSendAlert {
                ReceiveScheduleView(dateManager: dateManager, timeDotManager: timeDotManager, receivedData: receivedData, peerDisplayName: peer.displayName, isPresented: $isShowingReceiveModal, receivedPeers: $receivedPeers)
                    .presentationDetents([.medium])
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

//struct HalfSheet<SheetContent: View>: ViewModifier {
//    @Binding var isPresented: Bool
//    let sheetContent: SheetContent
//    
//    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> SheetContent) {
//        self._isPresented = isPresented
//        self.sheetContent = content()
//    }
//    
//    func body(content: Content) -> some View {
//        content
//            .background(
//                HalfSheetPresenter(isPresented: $isPresented, sheetContent: sheetContent)
//            )
//    }
//}
//
//private struct HalfSheetPresenter<SheetContent: View>: UIViewControllerRepresentable {
//    @Binding var isPresented: Bool
//    let sheetContent: SheetContent
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        UIViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        if isPresented {
//            let hostingController = UIHostingController(rootView: sheetContent)
//            hostingController.modalPresentationStyle = .pageSheet
//            uiViewController.present(hostingController, animated: true) {
//                if let presentationController = hostingController.presentationController as? UISheetPresentationController {
//                    presentationController.detents = [.medium()]
//                }
//            }
//        } else {
//            uiViewController.dismiss(animated: true, completion: nil)
//        }
//    }
//}
//
//extension View {
//    func halfSheet<SheetContent: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> SheetContent) -> some View {
//        self.modifier(HalfSheet(isPresented: isPresented, content: content))
//    }
//}



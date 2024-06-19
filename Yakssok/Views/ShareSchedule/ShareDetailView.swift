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
    
    @State private var isShowingReceiveModal = false
    @State private var isShowingAlert = false
    @State private var peerToSendAlert: MCPeerID?
    
    @ObservedObject var connectivityManager: MultipeerConnectivityManager
    
    
    var body: some View {
        VStack{
            TextField("Enter message", text: $messageToSend)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            
        }
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
            
            Text("스케줄 공유하기")
                .font(.subheadline)
                .frame(width: 300, height: 40)
                .background(AppColor.black)
                .foregroundColor(AppColor.white)
                .cornerRadius(90)
            
            
            
            
            
            
        }.onAppear {
            connectivityManager.startBrowsing()
            connectivityManager.receiveData { data, peerID in
                self.peerToSendAlert = peerID
                self.isShowingAlert = true
            }
        }
        .halfSheet(isPresented: $isShowingReceiveModal) {
            if let receivedData = connectivityManager.receivedData, let peer = self.peerToSendAlert {
                ReceivedDataView(receivedData: receivedData, peerDisplayName: peer.displayName, isPresented: $isShowingReceiveModal, receivedPeers: $receivedPeers)
            }
            
        }.alert(isPresented: $isShowingAlert) {
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



struct ReceivedDataView: View {
    var receivedData: String
    var peerDisplayName: String
    @Binding var isPresented: Bool
    @Binding var receivedPeers: [String]
    
    var body: some View {
        VStack {
            VStack(alignment:.leading){
                
                HStack{
                    Spacer()
                    
                    Rectangle()
                        .frame(width:50, height:5)
                        .foregroundColor(AppColor.darkgray)
                        .cornerRadius(15)
                    Spacer()
                }
                Button(action: {
                    isPresented = false
                }) {
                    Text("취소")
                        .foregroundColor(AppColor.orange)
                        .padding()
                }
                
                
            }
            Text("공유된 스케줄")
                .font(.title3)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Divider()
            
            Text("\(peerDisplayName)에서 스케줄을 공유하려고 합니다")
                .font(.caption)
                .foregroundColor(AppColor.darkgray)
                .padding(15)
            
            
            Text(receivedData)
                .padding()
            
            Spacer()
            
            Button(action: {
                receivedPeers.append(peerDisplayName)
                isPresented = false
            }) {
                Text("스케줄에 추가하기")
                    .font(.subheadline)
                    .frame(width: 300, height: 40)
                    .background(AppColor.black)
                    .foregroundColor(AppColor.white)
                    .cornerRadius(90)
            }
            
        }
        .padding()
    }
}

//
//  SharedPeer.swift
//  Yakssok
//
//  Created by 추서연 on 6/18/24.
//

import SwiftUI

struct SharedPeer: View {
    @Binding var receivedPeers: [String]
    
    var body: some View {
        HStack (alignment:.center) {
            
            Rectangle()
                .frame(width: 360, height: 60)
            
                .foregroundColor(AppColor.white)
            
                
                
                .overlay{
                    
                    HStack{
                        ForEach(receivedPeers, id: \.self) { peer in
                            Text(peer)
                                .padding(.vertical, 5)
                                .font(.caption)
                                .foregroundColor(AppColor.mint)
                                
                        }
                        
                        Text("에게 스케줄 공유 받음")
                            .foregroundColor(AppColor.darkgray)
                        
                    }.frame(width: 360, height: 60)
                       
                }
                .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AppColor.mint, lineWidth: 1) 
                    )
            
            
        }
        
        .font(.caption)
        .cornerRadius(15)
        .padding()
        
    }
}

struct SharedPeer_Previews: PreviewProvider {
    @State static var samplePeers = ["Peer1", "Peer2", "Peer3"]

    static var previews: some View {
        SharedPeer(receivedPeers: $samplePeers)
    }
}

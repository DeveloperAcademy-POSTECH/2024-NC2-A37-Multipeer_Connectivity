//
//  MultipeerConnectivityManager.swift
//  Yakssok
//
//  Created by 추서연 on 6/17/24.
//
import Foundation
import MultipeerConnectivity
import Combine

class MultipeerConnectivityManager: NSObject, ObservableObject {
    @Published var peers: [MCPeerID] = []
    @Published var receivedData: String?
    @Published var isReceivingData: Bool = false
    @Published var showInvitationAlert: Bool = false
    @Published var invitationPeer: MCPeerID?
    
    private let serviceType = "Yakssok"
   // private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    
    private(set) var myPeerId: MCPeerID
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    private var incomingDataHandler: ((Data, MCPeerID) -> Void)?
    
    override init() {
        myPeerId = MCPeerID(displayName: UIDevice.current.name)
        super.init()
        
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        browser.delegate = self
        
        startBrowsing()
    }
    
    func startBrowsing() {
        browser.startBrowsingForPeers()
        advertiser.startAdvertisingPeer()
    }
    
    func isConnected(peer: MCPeerID) -> Bool {
            return session.connectedPeers.contains(peer)
        }
    
    func invite(peer: MCPeerID) {
        browser.invitePeer(peer, to: session, withContext: nil, timeout: 10)
    }
    
    func send(text: String, to peer: MCPeerID) {
        let dataToSend = text.data(using: .utf8)!
        if session.connectedPeers.contains(peer) {
            do {
                try session.send(dataToSend, toPeers: [peer], with: .reliable)
                print("Sent message '\(text)' to \(peer.displayName)")
            } catch {
                print("Failed to send data to \(peer.displayName): \(error.localizedDescription)")
            }
        } else {
            print("Peer \(peer.displayName) is not connected")
        }
    }

    func receiveData(handler: @escaping (Data, MCPeerID) -> Void) {
        self.incomingDataHandler = handler
    }
    
    func updatePeerID(name: String) {
            let newPeerId = MCPeerID(displayName: name)
            myPeerId = newPeerId
            session.disconnect()
            
            session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
            session.delegate = self
            
            advertiser.stopAdvertisingPeer()
            advertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
            advertiser.delegate = self
            advertiser.startAdvertisingPeer()
            
            browser.stopBrowsingForPeers()
            browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
            browser.delegate = self
            browser.startBrowsingForPeers()
            
            notifyPeersAboutNameChange(name: name)
        }
        
        private func notifyPeersAboutNameChange(name: String) {
            let data = "nameUpdate:\(name)".data(using: .utf8)!
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Failed to send name update to peers: \(error.localizedDescription)")
            }
        }
    
}

extension MultipeerConnectivityManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            if state == .connected {
                if !self.peers.contains(peerID) {
                    self.peers.append(peerID)
                }
            } else if state == .notConnected {
                if let index = self.peers.firstIndex(of: peerID) {
                    self.peers.remove(at: index)
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.isReceivingData = true
            self.receivedData = String(data: data, encoding: .utf8)
            self.incomingDataHandler?(data, peerID)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

extension MultipeerConnectivityManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Failed to start advertising: \(error.localizedDescription)")
    }
}

extension MultipeerConnectivityManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            if !self.peers.contains(peerID) {
                self.peers.append(peerID)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            if let index = self.peers.firstIndex(of: peerID) {
                self.peers.remove(at: index)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Failed to start browsing: \(error.localizedDescription)")
    }
}

# 2024-NC2-A37-Multipeer_Connectivity
## 🎥 Youtube Link
(추후 만들어진 유튜브 링크 추가)

## 💡 About Multipeer Connectivity

**Multipeer Connectivity** 프레임워크는 근처 기기에서 제공되는 서비스를 발견하고,

 메시지 기반 데이터, 스트리밍 데이터, 그리고 파일과 같은 리소스를 통해 통신하는 서비스 입니다.

 - **MCSession**( 연결된 피어 장치 간의 통신관리 )
 - **MCNearbyServiceAdvertiser**( 주변에 있는 다른 장치들에게 세션 참여여부 전달 )
- **MCAdvertiserAssistant**( 연결 수락 표준 사용자 인터페이스 )
- **MCNearbyServiceBrowser**( 주변 장치 검색 )
- **MCBrowserViewController**( 주변 피어를 선택 표준 사용자 인터페이스 )
- **MCPeerID**( 고유하게 식별 장치 ID )

  
## 🎯 What we focus on?
>  Multipeer Connectivity 프레임 워크를 활용하여 데이터를 쉽게 전송하고, MCNearbyServiceAdvertiser와 MCNearbyServiceBrowser를 활용하여 사용자들이 주변의 다른 사용자를 찾고 연결할 수 있도록 합니다. <br/> 

## 💼 Use Case
>내 스케줄을 주변 친구의 앱에 띄우고, 약속이 가능한 시간을 앱 내에서 확인할 수 있다.<br/> 

## 🖼️ Prototype
| 스케줄 작성 | 스케줄 공유 | 공유 알림 | 스케줄 종합 | 스케줄 확정 | 
|--|--|--|--|--|
|<img src="https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A37-Multipeer_Connectivity/assets/88663477/498427fb-eff7-4729-bb32-3eb614bcdcd9" width=200> |<img src="https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A37-Multipeer_Connectivity/assets/88663477/ff782ee1-52c7-45e5-9b11-8c8b7c86275c" width=200> |<img src="https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A37-Multipeer_Connectivity/assets/88663477/9a499712-e233-493e-a0ae-c887322ea8d6" width=200>|<img src="https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A37-Multipeer_Connectivity/assets/88663477/2f663010-6b44-4d62-b724-cba98d874ec6" width=200> |<img src="https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A37-Multipeer_Connectivity/assets/88663477/6ef77423-1f94-407e-afeb-69ba5b757613" width=200> |

## 🙋🏻‍♂️UserFlow
1. 나의 스케줄을 입력하는 ***스케줄 작성***
2. 나의 스케줄을 공유하는 ***스케줄 공유***
3. 친구들의 스케줄을 한눈에 모아보는 ***스케줄 종합***
4. 약속 스케줄을 일시를 확정하는 ***스케줄 확정***



## 🛠️ About Code

### Scheduling View  
#### 약속 가능 시간 드래깅 제스처 표현
```swift

enum TimeDotStyle {
    case none
    case start
    case mid
    case end
    case unavailableStart
    case unavailableMid
    case unavailableEnd
    
    @ViewBuilder
    var style: some View {
        switch self {
        case .none:
            EmptyView()
        case .start:
            VStack {
                Spacer().frame(height: TimeDotManager.spacing)
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10, topTrailing: 10))
                    .foregroundStyle(AppColor.mint)
            }
        case .mid:
            Rectangle()
                .foregroundStyle(AppColor.mint)
        case .end:
            VStack {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 10, bottomTrailing: 10))
                    .foregroundStyle(AppColor.mint)
                Spacer().frame(height: TimeDotManager.spacing)
            }
        case .unavailableStart:
            VStack {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10, topTrailing: 10))
                    .foregroundStyle(.gray.opacity(0.2))
            }
        case .unavailableMid:
            Rectangle()
                .foregroundStyle(.gray.opacity(0.2))
        case .unavailableEnd:
            VStack {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 10, bottomTrailing: 10))
                    .foregroundStyle(.gray.opacity(0.2))
            }
        }
    }
}

 func updatedotStyles(for column: Int) {
        guard let startRow = dragStartRow, let endRow = dragEndRow else { return }
        
        if isErasing {
            for row in min(startRow, endRow)...max(startRow, endRow) {
                dotStyles[row][column] = .none
                feedbackGenerator.impactOccurred(intensity: 0.5)
            }
        } else {
            // Preserve existing rows
            var existingRows: [Int: TimeDotStyle] = [:]
            for row in dotStyles.indices {
                if dotStyles[row][column] != .none {
                    existingRows[row] = dotStyles[row][column]
                }
            }
            
            // Clear current column
            for row in dotStyles.indices {
                dotStyles[row][column] = .none
            }
            
            // Apply existing rows
            for (row, style) in existingRows {
                dotStyles[row][column] = style
            }
            
            // Apply new dragging rows
            for row in min(startRow, endRow)...max(startRow, endRow) {
                if row == min(startRow, endRow) {
                    dotStyles[row][column] = .start
                } else if row == max(startRow, endRow) {
                    dotStyles[row][column] = .end
                } else {
                    dotStyles[row][column] = .mid
                }
            }
            feedbackGenerator.impactOccurred(intensity: 0.5)
        }
        
        // Adjust mid dots if their neighbors are erased
        for row in dotStyles.indices {
            if dotStyles[row][column] == .mid {
                if row > 0 && dotStyles[row - 1][column] != .start && dotStyles[row - 1][column] != .mid {
                    dotStyles[row][column] = .start
                }
                if row < dotStyles.count - 1 && dotStyles[row + 1][column] != .end && dotStyles[row + 1][column] != .mid {
                    dotStyles[row][column] = .end
                }
            }
        }
        
        // Adjust start dots if their neighbors are erased
        for row in dotStyles.indices {
            if dotStyles[row][column] == .start {
                if row < dotStyles.count - 1 && dotStyles[row + 1][column] != .mid && dotStyles[row + 1][column] != .end {
                    dotStyles[row][column] = .none
                }
            }
        }
        
        // Adjust end dots if their neighbors are erased
        for row in dotStyles.indices {
            if dotStyles[row][column] == .end {
                if row > 0 && dotStyles[row - 1][column] != .mid && dotStyles[row - 1][column] != .start {
                    dotStyles[row][column] = .none
                }
            }
        }
    }
```

### MultipeerConnectivity  
#### 데이터 전송 및 연결 상태 변화 관리
```swift
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

```

//
//  TimeDotStyle.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/20/24.
//

import SwiftUI

enum TimeDotStyle {
    case none
    case start
    case mid
    case end
    case unavailableStart
    case unavailableMid
    case unavailableEnd
    case transparentStart
    case transparentMid
    case transparentEnd
    case overlapStart
    case overlapMid
    case overlapEnd
    case overlapStartStart
    case overlapEndEnd
    
    @ViewBuilder
    var style: some View {
        @State var showSheet: Bool = false
        
        switch self {
        case .none:
            EmptyView()
        case .start, .transparentStart, .overlapStart, .overlapStartStart:
            VStack {
                if !isTransparent {
                    Spacer().frame(height: TimeDotManager.spacing)
                }
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10, topTrailing: 10))
                    .foregroundStyle(AppColor.mint.opacity(isTransparent ? 0.3 : 1.0))
            }
            .background(isOverlapped && self != .overlapStartStart ? AppColor.mint.opacity(0.3) : .clear)
        case .mid, .transparentMid, .overlapMid:
            Rectangle()
                .foregroundStyle(AppColor.mint.opacity(isTransparent ? 0.3 : 1.0))
        case .end, .transparentEnd, .overlapEnd, .overlapEndEnd:
            VStack {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 10, bottomTrailing: 10))
                    .foregroundStyle(AppColor.mint.opacity(isTransparent ? 0.3 : 1.0))
                if !isTransparent {
                    Spacer().frame(height: TimeDotManager.spacing)
                }
            }
            .background(isOverlapped && self != .overlapEndEnd ? AppColor.mint.opacity(0.3) : .clear)
        case .unavailableStart:
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10, topTrailing: 10))
                .foregroundStyle(.gray.opacity(0.2))
        case .unavailableMid:
            Rectangle()
                .foregroundStyle(.gray.opacity(0.2))
        case .unavailableEnd:
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 10, bottomTrailing: 10))
                .foregroundStyle(.gray.opacity(0.2))
        }
    }
    
    var isTransparent: Bool {
        return self == .transparentStart || self == .transparentMid || self == .transparentEnd
    }
    var isOverlapped: Bool {
        return self == .overlapStart || self == .overlapMid || self == .overlapEnd || self == .overlapEndEnd || self == .overlapStartStart
    }
}

//
//  TimeBlock.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/14/24.
//


import SwiftUI
import UIKit

struct TimeBlock: View {
    var timeDotManager: TimeDotManager
    var dateManager: DateManager
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TimeBlockTable(timeDotManager: timeDotManager, dateManager: dateManager)
            TimeDetailHeader
        }
        .padding(.horizontal)
    }
}

@ViewBuilder
private func TimeBlockTable(timeDotManager: TimeDotManager, dateManager: DateManager) -> some View {
    VStack {
        VStack(spacing: 0) {
            ForEach(0..<timeDotManager.dotStyles.count, id: \.self) { row in
                HStack(spacing: TimeDotManager.spacing) {
                    ForEach(0..<timeDotManager.dotStyles[row].count, id: \.self) { col in
                        TimeDot(dateManager: dateManager, timeDotManager: timeDotManager, row: row, col: col)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .gesture(DragGesture(minimumDistance: 0)
            .onChanged { value in
                timeDotManager.handleDrag(at: value.location, dateManager: dateManager)
            }
            .onEnded { _ in
                timeDotManager.finalizeDrag()
            }
        )
        .onAppear {
            timeDotManager.prepareFeedback()
        }
        .shadow(radius: 2, x: 1, y: 1)
        ClearButtonRow {
            timeDotManager.clearDots()
        }
    }
}

private struct TimeDot: View {
    var dateManager: DateManager
    var timeDotManager: TimeDotManager
    var row: Int
    var col: Int
    
    var body: some View {
        Circle()
            .frame(width: TimeDotManager.dotSize, height: TimeDotManager.dotSize)
            .foregroundStyle(.gray)
            .padding(TimeDotManager.spacing)
            .contentShape(Rectangle()) // 터치 영역 넓힘
            .overlay {
                if timeDotManager.isPastDay(col: col, dateManager: dateManager) {
                    if row == 0 {
                        TimeDotStyle.unavailableStart.style
                    } else if row == timeDotManager.dotStyles.indices.count - 1 {
                        TimeDotStyle.unavailableEnd.style
                    } else {
                        TimeDotStyle.unavailableMid.style
                    }
                } else {
                    timeDotManager.dotStyles[row][col].style
                }
            }
    }
}

private var TimeDetailHeader: some View {
    VStack(spacing: 12.8) {
        Spacer().frame(height: 4)
        Text("09:00")
        Text("10:00")
        Text("11:00")
        Text("12:00")
        Text("13:00")
        Text("14:00")
        Text("15:00")
        Text("16:00")
        Text("17:00")
        Text("18:00")
        Text("19:00")
        Text("20:00")
        Text("21:00")
        Text("22:00")
        Text("23:00")
        Text("24:00")
    }
    .font(.caption2)
    .foregroundStyle(.gray)
}

private func ClearButtonRow(clear: @escaping () -> Void) -> some View {
    return HStack {
        Spacer()
        Button{
            clear()
        } label: {
            Text("초기화")
                .foregroundStyle(.gray)
                .font(.caption2)
                .padding(4)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: 1)
                )
        }
    }
    .padding(.horizontal, 48)
    .padding(.bottom, 8)
}

struct TimeBlock_Previews: PreviewProvider {
    static var previews: some View {
        TimeBlock(timeDotManager: TimeDotManager(), dateManager: DateManager())
    }
}

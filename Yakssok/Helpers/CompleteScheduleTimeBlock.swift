//
//  CompleteScheduleTimeBlock.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/19/24.
//


import SwiftUI
import UIKit

struct CompleteScheduleTimeBlock: View {
    var timeDotManager: TimeDotManager
    var dateManager: DateManager
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TimeBlockTable(timeDotManager: timeDotManager, dateManager: dateManager, showSheet: $showSheet)
            TimeDetailHeader
        }
        .padding(.horizontal)
        .onAppear {
            timeDotManager.applyScheduleData(tempData, forWeekStart: tempData[0].selectedWeekStart)
        }
        .sheet(isPresented: $showSheet) {
            CompleteScheduleSheetView(isPresented: $showSheet)
                .presentationDetents([.medium])
        }
    }
}

@ViewBuilder
private func TimeBlockTable(timeDotManager: TimeDotManager, dateManager: DateManager, showSheet: Binding<Bool>) -> some View {
    VStack {
        VStack(spacing: 0) {
            ForEach(0..<timeDotManager.dotStyles.count, id: \.self) { row in
                HStack(spacing: TimeDotManager.spacing) {
                    ForEach(0..<timeDotManager.dotStyles[row].count, id: \.self) { col in
                        TimeDot(dateManager: dateManager, timeDotManager: timeDotManager, row: row, col: col, showSheet: showSheet)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 2, x: 1, y: 1)
        
        Rectangle()
            .fill(.clear)
            .frame(height: 0)
            .padding(.horizontal, 48)
    }
}

private struct TimeDot: View {
    var dateManager: DateManager
    var timeDotManager: TimeDotManager
    var row: Int
    var col: Int
    
    @Binding var showSheet: Bool
    
    var body: some View {
        Circle()
            .frame(width: TimeDotManager.dotSize, height: TimeDotManager.dotSize)
            .foregroundStyle(.gray)
            .padding(TimeDotManager.spacing)
            .overlay {
                timeDotManager.dotStyles[row][col].style
            }
            .onTapGesture {
                if timeDotManager.dotStyles[row][col].isOverlapped {
                    showSheet = true
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

struct CompleteScheduleTimeBlock_Previews: PreviewProvider {
    static var previews: some View {
        CompleteScheduleTimeBlock(timeDotManager: TimeDotManager(), dateManager: DateManager())
    }
}

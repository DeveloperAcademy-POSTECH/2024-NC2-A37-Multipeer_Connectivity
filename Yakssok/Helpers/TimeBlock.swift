//
//  TimeBlock.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/14/24.
//


import SwiftUI
import UIKit

struct TimeBlock: View {
    // TODO: - dotStyles 2차원 배열을 날짜 정보도 함께 담고 있는 데이터 구조로 변경
    // TODO: - 현재일 이전 날짜 disabled
    var data: DataManager
    
    @State private var currentColumn: Int? = nil
    @State private var isErasing: Bool = false
    @State private var dragStartRow: Int? = nil
    @State private var dragEndRow: Int? = nil
    
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TimeBlockTable
            TimeDetailHeader
        }
        .padding(.horizontal)
    }
}

extension TimeBlock {
    private func handleDrag(at location: CGPoint) {
        let totalHeight = dotSize + spacing * 2
        let totalWidth = dotSize + spacing * 3
        let row = Int(location.y / totalHeight)
        let col = Int(location.x / totalWidth)
        
        guard row >= 0, row < data.dotStyles.count, col >= 0, col < data.dotStyles[row].count else { return }
        
        if currentColumn == nil {
            currentColumn = col
            isErasing = data.dotStyles[row][col] != .none
            dragStartRow = row
            dragEndRow = row
        } else if currentColumn != col {
            return
        }
        
        dragEndRow = row
        updatedotStyles(for: col)
    }
    
    private func updatedotStyles(for column: Int) {
        guard let startRow = dragStartRow, let endRow = dragEndRow else { return }
        
        if isErasing {
            for row in min(startRow, endRow)...max(startRow, endRow) {
                data.dotStyles[row][column] = .none
                feedbackGenerator.impactOccurred(intensity: 0.5)
            }
        } else {
            // Preserve existing rows
            var existingRows: [Int: TimeDotStyle] = [:]
            for row in data.dotStyles.indices {
                if data.dotStyles[row][column] != .none {
                    existingRows[row] = data.dotStyles[row][column]
                }
            }
            
            // Clear current column
            for row in data.dotStyles.indices {
                data.dotStyles[row][column] = .none
            }
            
            // Apply existing rows
            for (row, style) in existingRows {
                data.dotStyles[row][column] = style
            }
            
            // Apply new dragging rows
            for row in min(startRow, endRow)...max(startRow, endRow) {
                if row == min(startRow, endRow) {
                    data.dotStyles[row][column] = .start
                } else if row == max(startRow, endRow) {
                    data.dotStyles[row][column] = .end
                } else {
                    data.dotStyles[row][column] = .mid
                }
            }
            feedbackGenerator.impactOccurred(intensity: 0.5)
        }
        
        // Adjust mid dots if their neighbors are erased
        for row in data.dotStyles.indices {
            if data.dotStyles[row][column] == .mid {
                if row > 0 && data.dotStyles[row - 1][column] != .start && data.dotStyles[row - 1][column] != .mid {
                    data.dotStyles[row][column] = .start
                }
                if row < data.dotStyles.count - 1 && data.dotStyles[row + 1][column] != .end && data.dotStyles[row + 1][column] != .mid {
                    data.dotStyles[row][column] = .end
                }
            }
        }
        
        // Adjust start dots if their neighbors are erased
        for row in data.dotStyles.indices {
            if data.dotStyles[row][column] == .start {
                if row < data.dotStyles.count - 1 && data.dotStyles[row + 1][column] != .mid && data.dotStyles[row + 1][column] != .end {
                    data.dotStyles[row][column] = .none
                }
            }
        }
        
        // Adjust end dots if their neighbors are erased
        for row in data.dotStyles.indices {
            if data.dotStyles[row][column] == .end {
                if row > 0 && data.dotStyles[row - 1][column] != .mid && data.dotStyles[row - 1][column] != .start {
                    data.dotStyles[row][column] = .none
                }
            }
        }
    }
    
    private func finalizeDrag() {
        currentColumn = nil
        dragStartRow = nil
        dragEndRow = nil
    }
    
    private func clearDots() {
        for row in data.dotStyles.indices {
            for col in data.dotStyles[row].indices {
                if data.dotStyles[row][col] != .none {
                    data.dotStyles[row][col] = .none
                }
            }
        }
    }
    
    private var TimeBlockTable: some View {
        VStack {
            VStack(spacing: 0) {
                ForEach(0..<data.dotStyles.count, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<data.dotStyles[row].count, id: \.self) { col in
                            TimeDot(data: data, row: row, col: col)
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
                    handleDrag(at: value.location)
                }
                .onEnded { _ in
                    finalizeDrag()
                }
            )
            .onAppear {
                feedbackGenerator.prepare()
            }
            ClearButtonRow {
                clearDots()
            }
        }
    }
}

struct TimeBlock_Previews: PreviewProvider {
    static var previews: some View {
        TimeBlock(data: DataManager())
    }
}

private let dotSize: CGFloat = 6
private let spacing: CGFloat = 10

private struct TimeDot: View {
//    @Binding var style: TimeDotStyle
    var data: DataManager
    var row: Int
    var col: Int
    
    var body: some View {
        Circle()
            .frame(width: dotSize, height: dotSize)
            .foregroundStyle(.gray)
            .padding(spacing)
            .contentShape(Rectangle()) // 터치 영역 넓힘
            .overlay {
                data.dotStyles[row][col].style
            }
    }
}

enum TimeDotStyle {
    case none
    case start
    case mid
    case end
    
    @ViewBuilder
    var style: some View {
        switch self {
        case .none:
            EmptyView()
        case .start:
            VStack {
                Spacer().frame(height: spacing)
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
                Spacer().frame(height: spacing)
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

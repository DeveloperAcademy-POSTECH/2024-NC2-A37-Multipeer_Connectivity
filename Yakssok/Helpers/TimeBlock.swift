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
    @State private var dotStyles: [[TimeDotStyle]] = Array(repeating: Array(repeating: .none, count: 7), count: 16)
    @State private var currentColumn: Int? = nil
    @State private var isErasing: Bool = false
    @State private var dragStartRow: Int? = nil
    @State private var dragEndRow: Int? = nil
    
   // @State private var selectedDots: [SelectedDot] = []


    
    
    let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    let timeSlots = ["9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm"]

    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<dotStyles.count, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<dotStyles[row].count, id: \.self) { col in
                        TimeDot(style: $dotStyles[row][col])
                    }
                }
            }
          

            
            
            
            Text("Selected Dots:")
                .font(.headline)
                .padding()
/*
            ForEach(dotStyles.indices, id: \.self) { row in
                ForEach(dotStyles[row].indices, id: \.self) { col in
                    if dotStyles[row][col] == .start || dotStyles[row][col] == .end {
                        let column = currentColumn ?? col
                        let startRow = dragStartRow ?? row
                        let endRow = dragEndRow ?? row
                        
                        if dotStyles[row][col] == .start {
                            Text("Start Dot:  \(daysOfWeek[column]), \(timeSlots[startRow])")
                                .padding(.horizontal)
                        } else if dotStyles[row][col] == .end {
                            Text("Start Dot:  \(daysOfWeek[column]), \(timeSlots[endRow])")
                                .padding(.horizontal)
                        }
                    }
                }
            }*/
        }
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
        .overlay(
                    VStack {
                        if let startColumn = currentColumn,
                           let startRow = dragStartRow,
                           let endRow = dragEndRow,
                           dotStyles.indices.contains(startRow) && dotStyles.indices.contains(endRow) {
                            Text("Start Dot: Column \(startColumn), Row \(startRow)")
                                .padding()
                            Text("End Dot: Column \(startColumn), Row \(endRow)")
                                .padding()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(), alignment: .topLeading
                )
        
        
            
        
    }
    
}

extension TimeBlock {
    private func handleDrag(at location: CGPoint) {
        let totalHeight = dotSize + spacing * 2
        let totalWidth = dotSize + spacing * 3
        let row = Int(location.y / totalHeight)
        let col = Int(location.x / totalWidth)
        
        guard row >= 0, row < dotStyles.count, col >= 0, col < dotStyles[row].count else { return }
        
        if currentColumn == nil {
            currentColumn = col
            isErasing = dotStyles[row][col] != .none
            dragStartRow = row
            dragEndRow = row
        } else if currentColumn != col {
            return
        }
        
        dragEndRow = row
        updateDotStyles(for: col)
    }
    
    private func updateDotStyles(for column: Int) {
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
//ㄴ
            
    }
    
    private func finalizeDrag() {
        currentColumn = nil
        dragStartRow = nil
        dragEndRow = nil
    }
}

struct TimeBlock_Previews: PreviewProvider {
    static var previews: some View {
        TimeBlock()
    }
}

private let dotSize: CGFloat = 6
private let spacing: CGFloat = 10

struct TimeDot: View {
    @Binding var style: TimeDotStyle
    
    var body: some View {
        Circle()
            .frame(width: dotSize, height: dotSize)
            .foregroundStyle(AppColor.darkgray)
            .padding(spacing)
            .contentShape(Rectangle()) // 터치 영역 넓힘
            .overlay {
                style.style
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



struct SelectedDot: Hashable {
    let startColumn: Int
    let startRow: Int
    let endRow: Int
}

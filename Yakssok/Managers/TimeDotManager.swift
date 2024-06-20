//
//  TimeDotManager.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/19/24.
//

import UIKit
import SwiftUI

@Observable
class TimeDotManager {
    var dotStyles: [[TimeDotStyle]] = Array(repeating: Array(repeating: .none, count: 7), count: 16)
    
    static let dotSize: CGFloat = 6
    static let spacing: CGFloat = 10
    
    private var currentColumn: Int? = nil
    private var isErasing: Bool = false
    private var dragStartRow: Int? = nil
    private var dragEndRow: Int? = nil
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
}

extension TimeDotManager {
    func calcSelectedTime(dateManager: DateManager) -> [SelectedTime] {
        var selectedTimes: [SelectedTime] = []
        
        var startTime: Date?
        var endTime: Date?
        
        for col in 0...6 {
            for row in dotStyles.indices {
                if dotStyles[row][col] == .start {
                    startTime = dateManager.calendar.date(byAdding: .hour, value: row, to: dateManager.currentWeekStart)!
                    startTime = dateManager.calendar.date(byAdding: .day, value: col, to: startTime!)!
                } else if dotStyles[row][col] == .end {
                    endTime = dateManager.calendar.date(byAdding: .hour, value: row, to: dateManager.currentWeekStart)!
                    endTime = dateManager.calendar.date(byAdding: .day, value: col, to: endTime!)!
                    
                    if let startTime = startTime, let endTime = endTime {
                        selectedTimes.append(.init(day: dateManager.calendar.dateComponents([.day], from: startTime).day!, startTime: startTime, endTime: endTime))
                    }
                    
                    startTime = nil
                    endTime = nil
                }
            }
        }
        
        return selectedTimes
    }
    
    func applyScheduleData(_ scheduleData: [ScheduleData], forWeekStart weekStart: Date) {
        var scheduleCount = Array(repeating: Array(repeating: 0, count: 7), count: 16)
        
        for data in scheduleData {
            for selectedTime in data.selectedTimes {
                let col = Calendar.current.dateComponents([.day], from: weekStart, to: selectedTime.startTime).day!
                let startRow = Calendar.current.component(.hour, from: selectedTime.startTime) - 9
                let endRow = Calendar.current.component(.hour, from: selectedTime.endTime) - 9
                
                if startRow >= 0 && endRow < dotStyles.count {
                    if dotStyles[startRow][col] == .end || dotStyles[startRow][col] == .transparentEnd {
                        dotStyles[startRow][col] = .transparentMid
                    } else if dotStyles[startRow][col] != .transparentMid {
                        dotStyles[startRow][col] = .transparentStart
                    }
                    scheduleCount[startRow][col] += 1
                    
                    if dotStyles[endRow][col] == .start || dotStyles[endRow][col] == .transparentStart {
                        dotStyles[endRow][col] = .transparentMid
                    } else if dotStyles[endRow][col] != .transparentMid {
                        dotStyles[endRow][col] = .transparentEnd
                    }
                    scheduleCount[endRow][col] += 1
                    
                    for row in (startRow + 1)..<endRow {
                        dotStyles[row][col] = .transparentMid
                        scheduleCount[row][col] += 1
                    }
                }
            }
        }
        
        highlightOverlappingSchedules(scheduleCount, scheduleData: scheduleData)
    }
    
    func highlightOverlappingSchedules(_ scheduleCount: [[Int]], scheduleData: [ScheduleData]) {
        for col in 0..<7 {
            var inOverlap = false
            var temp: TimeDotStyle = .none
            
            for row in 0..<16 {
                if scheduleCount[row][col] >= scheduleData.count {
                    if !inOverlap {
                        // Start of an overlapping block
                        temp = dotStyles[row][col]
                        if dotStyles[row - 1][col] == .none {
                            dotStyles[row][col] = .overlapStartStart
                        } else {
                            dotStyles[row][col] = .overlapStart
                        }
                        inOverlap = true
                    } else {
                        // Middle of an overlapping block
                        if dotStyles[row][col] == .transparentMid || dotStyles[row][col] == .transparentEnd {
                            dotStyles[row][col] = .overlapMid
                        }
                    }
                } else {
                    if inOverlap {
                        // End of an overlapping block
                        if dotStyles[row - 1][col] == .overlapMid {
                            if dotStyles[row][col] == .none{
                                dotStyles[row - 1][col] = .overlapEndEnd
                            } else {
                                dotStyles[row - 1][col] = .overlapEnd
                            }
                        } else if dotStyles[row - 1][col] == .start {
                            dotStyles[row - 1][col] = temp
                        }
                        inOverlap = false
                    }
                }
            }
            if inOverlap {
                // If the last row was part of an overlapping block, mark it as the end
                if dotStyles[15][col] == .mid {
                    dotStyles[15][col] = .end
                }
            }
        }
    }
    
    func isPastDay(col: Int, dateManager: DateManager) -> Bool {
        let currentDay = dateManager.calendar.date(byAdding: .day, value: col, to: dateManager.currentWeekStart)!
        let difference = dateManager.calendar.dateComponents([.day], from: .now, to: currentDay).day!
        if difference < 0 {
            return true
        } else {
            return false
        }
    }
    
    func handleDrag(at location: CGPoint, dateManager: DateManager) {
        let totalHeight = TimeDotManager.dotSize + TimeDotManager.spacing * 2
        let totalWidth = TimeDotManager.dotSize + TimeDotManager.spacing * 3
        let row = Int(location.y / totalHeight)
        let col = Int(location.x / totalWidth)
        
        guard row >= 0, row < dotStyles.count, col >= 0, col < dotStyles[row].count else { return }
        
        // 현재 날짜 이전의 날짜는 무시
        if isPastDay(col: col, dateManager: dateManager) { return }
        
        if currentColumn == nil {
            currentColumn = col
            isErasing = dotStyles[row][col] != .none
            dragStartRow = row
            dragEndRow = row
        } else if currentColumn != col {
            return
        }
        
        dragEndRow = row
        updatedotStyles(for: col)
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
    
    func finalizeDrag() {
        currentColumn = nil
        dragStartRow = nil
        dragEndRow = nil
    }
    
    func clearDots() {
        for row in dotStyles.indices {
            for col in dotStyles[row].indices {
                if dotStyles[row][col] != .none {
                    dotStyles[row][col] = .none
                }
            }
        }
    }
    
    func prepareFeedback() {
        feedbackGenerator.prepare()
    }
}

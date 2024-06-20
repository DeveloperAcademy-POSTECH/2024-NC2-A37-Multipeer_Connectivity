//
//  Week.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/20/24.
//

import Foundation

struct Week: Identifiable {
    let id = UUID()
    let weekStart: Date
    let dates: [Date]
    let year: Int
    let month: Int
    let weekOfMonth: Int
}

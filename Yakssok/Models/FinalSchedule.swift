//
//  FinalSchedule.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/20/24.
//

import Foundation

struct FinalSchedule: Hashable {
    var participants: [String]
    var date: String
    var startTime: Date
    var endTime: Date
    var duration: Int
}

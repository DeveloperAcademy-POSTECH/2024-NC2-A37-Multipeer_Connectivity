//
//  Schedule.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/20/24.
//

import Foundation

struct ScheduleData: Hashable {
    var name: String
    var selectedWeekStart: Date
    var selectedTimes: [SelectedTime]
}

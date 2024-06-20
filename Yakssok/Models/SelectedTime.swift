//
//  SelectedTime.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/20/24.
//

import Foundation

struct SelectedTime: Hashable {
    var day: Int
    var startTime: Date
    var endTime: Date
    var duration: Int {
        Calendar.current.dateComponents([.hour], from: startTime, to: endTime).hour!
    }
}

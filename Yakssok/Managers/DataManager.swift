//
//  DataManager.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/18/24.
//

import Foundation

@Observable
class DataManager {
    var dotStyles: [[TimeDotStyle]] = Array(repeating: Array(repeating: .none, count: 7), count: 16)
}

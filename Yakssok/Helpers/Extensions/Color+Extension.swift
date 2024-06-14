//
//  Color+Extension.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/14/24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

struct AppColor {
    static let mint = Color(hex: "66D9CB")
    static let background = Color(hex: "F4F4F4")
    static let orange = Color(hex: "F12B1E")
}

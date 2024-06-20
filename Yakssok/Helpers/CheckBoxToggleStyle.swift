//
//  CheckBoxToggleStyle.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/19/24.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle() // toggle the state binding
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .imageScale(.medium)
                    .foregroundStyle(configuration.isOn ? AppColor.mint : .gray)
                configuration.label
            }
        })
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }
}

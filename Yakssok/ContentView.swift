//
//  ContentView.swift
//  Yakssok
//
//  Created by Eom Chanwoo on 6/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView(dateManager: DateManager(), timeDotManager: TimeDotManager())
    }
}

#Preview {
    ContentView()
}

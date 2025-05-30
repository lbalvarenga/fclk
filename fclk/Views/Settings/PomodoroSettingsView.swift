//
//  AnalogClockSettingsView.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct PomodoroSettingsView: View {
    var body: some View {
        VStack {
            Text("Pomodoro Settings")
        }
    }
}

#if DEBUG
    #Preview {
        SettingsView()
            .environmentObject(SettingsStore())
    }
#endif

//
//  AnalogClockSettingsView.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct DigitalClockSettingsView: View {
    @EnvironmentObject var settingsStore: SettingsStore

    var body: some View {
        VStack {
            Text("Digital Clock Settings")
                .font(.headline)
                .padding()

            Toggle("Show Seconds", isOn: $settingsStore.settings.DCShowSeconds)
            Toggle(
                "Use 24-Hour Format",
                isOn: $settingsStore.settings.DCUse24HourClock
            )
        }
    }
}

#if DEBUG
    #Preview {
        SettingsView()
            .environmentObject(SettingsStore())
    }
#endif

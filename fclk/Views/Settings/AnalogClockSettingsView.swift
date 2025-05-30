//
//  AnalogClockSettingsView.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct AnalogClockSettingsView: View {
    @ObservedObject var settingsStore = SettingsStore.shared

    var body: some View {
        VStack {
            Text("Analog Clock Settings")
                .font(.headline)
                .padding()

            Toggle("Show Seconds Hand", isOn: $settingsStore.settings.ACShowSecondsHand)
            Toggle("Smooth Hands", isOn: $settingsStore.settings.ACSmoothHands)
        }
    }
}

#if DEBUG
    #Preview {
        SettingsView()
    }
#endif

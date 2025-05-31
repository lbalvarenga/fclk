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

            Toggle(
                "Show Seconds Hand",
                isOn: $settingsStore.settings.ACShowSecondsHand
            )
            Toggle(isOn: $settingsStore.settings.ACSmoothHands) {
                HStack(spacing: 8) {
                    Text("Smooth Hands")
                    Label("High CPU", systemImage: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange) // Style the warning color
                                    .font(.headline)
                                    .padding(4)
                                    .background(Color.yellow.opacity(0.2))
                                    .cornerRadius(5)
//                    Image(systemName: "exclamationmark.triangle.fill")
//                        .foregroundColor(.yellow)
                }
                .help("Enabling this may increase CPU load.")
            }
        }
    }
}

#if DEBUG
    #Preview {
        SettingsView()
    }
#endif

//
//  SettingsView.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsStore: SettingsStore

    var body: some View {
        TabView {
            Tab("General", systemImage: "gear") {
                Picker(
                    "Tooltip Position",
                    selection: $settingsStore.settings.tooltipPosition
                ) {
                    ForEach(TooltipPosition.allCases) { position in
                        Text(position.rawValue.capitalized).tag(position)
                    }
                }

                Toggle(
                    "Always on Top",
                    isOn: $settingsStore.settings.alwaysOnTop
                )

                Picker(
                    "Clock Type",
                    selection: $settingsStore.settings.clockType
                ) {
                    ForEach(ClockType.allCases) { clockType in
                        Text(clockType.rawValue.capitalized).tag(clockType)
                    }
                }
                .pickerStyle(.segmented)

                if settingsStore.settings.clockType == .digital {
                    DigitalClockSettingsView()
                } else if settingsStore.settings.clockType == .analog {
                    AnalogClockSettingsView()
                } else {
                    PomodoroSettingsView()
                }
            }
        }
        .scenePadding()
        .frame(maxWidth: 350, minHeight: 200)
    }
}

#if DEBUG
    #Preview {
        SettingsView()
            .environmentObject(SettingsStore())
    }
#endif

//
//  DigitalClockView.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct DigitalClockView: View {
    @ObservedObject var settingsStore = SettingsStore.shared
    let currentTime: Date

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        if settingsStore.settings.DCUse24HourClock {
            // 24-hour format
            formatter.dateFormat =
                settingsStore.settings.DCShowSeconds ? "HH:mm:ss" : "HH:mm"
        } else {
            // 12-hour format
            formatter.dateFormat =
                settingsStore.settings.DCShowSeconds ? "hh:mm:ss" : "h:mm"
        }
        
        return formatter
    }

    private var amPmFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        return formatter
    }

    private let clockFontSize: CGFloat = 500

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {  // Use .firstTextBaseline for better alignment of different font sizes
            Text(
                timeFormatter.string(from: currentTime)
                    + (settingsStore.settings.DCUse24HourClock
                        ? (" " + amPmFormatter.string(from: currentTime).uppercased())
                        : "")
            )
            .font(
                .system(
                    size: clockFontSize,
                    weight: .bold,
                    design: .monospaced
                )
            )
        }
        .minimumScaleFactor(0.01)
        .lineLimit(1)  // Ensure it stays on one line
    }
}

#if DEBUG
    #Preview {
        BaseClockView(settingsStore: SettingsStore())
    }
#endif

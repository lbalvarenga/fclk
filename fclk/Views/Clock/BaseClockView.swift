//
//  ContentView.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct BaseClockView: View {
    @ObservedObject var settingsStore = SettingsStore.shared
    @State private var isHovering: Bool = false

    @State private var time: Date = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var body: some View {

        VStack(spacing: 5) {
            // Tooltip (on hover)
            if settingsStore.settings.tooltipPosition != .bottom {
                TooltipView(isHoveringClock: $isHovering)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .bottom).combined(
                                with: .opacity
                            ),
                            removal: .move(edge: .bottom).combined(
                                with: .opacity
                            )
                        )
                    )
            }

            ZStack {
                if settingsStore.settings.clockType == .digital {
                    DigitalClockView(currentTime: time)
                } else if settingsStore.settings.clockType == .analog {
                    AnalogClockView(currentTime: time)
                } else {
                    PomodoroView()
                }
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
            )
            .padding(20)
            .background(.ultraThinMaterial)
            .cornerRadius(15)

            if settingsStore.settings.tooltipPosition == .bottom {
                TooltipView(isHoveringClock: $isHovering)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top).combined(
                                with: .opacity
                            ),
                            removal: .move(edge: .top).combined(
                                with: .opacity
                            )
                        )
                    )
            }
        }
        .onReceive(timer) { input in self.time = input }
        .animation(
            .spring(response: 0.3, dampingFraction: 0.7),
            value: isHovering
        )
        .onHover(perform: { isHovering in
            self.isHovering = isHovering
        })
        .background(
            WindowAspectRatioController()
        )
    }
}

#if DEBUG
    //    #Preview {
    //        BaseClockView(settingsStore: SettingsStore())
    //    }
#endif

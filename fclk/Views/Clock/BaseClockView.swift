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

    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var body: some View {
        TimelineView(.animation) { context in
            let hrTime = context.date

            VStack(spacing: 5) {
                // Tooltip (on hover)
                if settingsStore.settings.tooltipPosition == .top {
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
                        DigitalClockView(currentTime: hrTime)
                    } else if settingsStore.settings.clockType == .analog {
                        AnalogClockView(currentTime: hrTime)
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
}

#if DEBUG
//    #Preview {
//        BaseClockView(settingsStore: SettingsStore())
//    }
#endif

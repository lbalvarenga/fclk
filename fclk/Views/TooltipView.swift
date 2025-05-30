//
//  TooltipView.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct TooltipView: View {
    @ObservedObject var settingsStore = SettingsStore.shared
    let isHoveringClock: Binding<Bool>

    @State private var isHoveringTooltip: Bool

    init(isHoveringClock: Binding<Bool>) {
        self.isHoveringClock = isHoveringClock
        self.isHoveringTooltip = false
    }

    var body: some View {
        if isHoveringClock.wrappedValue {
            HStack {
                HStack {
                    RedTrafficLightButton(engaged: isHoveringTooltip) {
                        NSApplication.shared.terminate(nil)
                    }

                    if #available(macOS 14.0, *) {
                        SettingsLink {
                            Image(systemName: "gear")
                                .foregroundColor(.primary)

                        }
                        .buttonStyle(.plain)
                    } else {
                        Button {
                            NSApp.sendAction(
                                Selector(("showSettingsWindow:")),
                                to: nil,
                                from: nil
                            )
                        } label: {
                            Image(systemName: "gear")
                                .foregroundColor(.primary)
                        }
                        .buttonStyle(.plain)
                    }

                    Picker(
                        "Clock Type",
                        selection: $settingsStore.settings.clockType
                    ) {
                        ForEach(ClockType.allCases) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .labelsHidden()
                }
                .pickerStyle(.segmented)
                .padding(10)
                //                .background(Color.black.opacity(0.3))
                .background(.ultraThinMaterial)
                .cornerRadius(10)
            }
            .onHover(perform: { isHovering in
                isHoveringTooltip = isHovering
            })
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: 50
            )
        } else {
            Rectangle()
                .fill(.clear)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 50,
                    maxHeight: 50
                )
        }
    }
}

//
//  TooltipView.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct TooltipView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    let isHovering: Binding<Bool>

    var body: some View {
        if isHovering.wrappedValue {
            HStack {
                HStack {
                    Picker(
                        "Clock Type",
                        selection: $settingsStore.settings.clockType
                    ) {
                        ForEach(ClockType.allCases) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                }
                .pickerStyle(.segmented)
                .padding(10)
                //                .background(Color.black.opacity(0.3))
                .background(.ultraThinMaterial)
                .cornerRadius(10)
            }
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

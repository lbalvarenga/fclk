//
//  ContentView.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct BaseClockView: View {
    @State private var isHovering: Bool = false
    @State private var clockType: ClockType = .digital

    @State private var currentTime: Date = Date()
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var body: some View {
        VStack(spacing: 10) {
            // Tooltip (on hover)
            if isHovering {
                HStack {
                    HStack {
                        Picker("Clock Type", selection: $clockType) {
                            ForEach(ClockType.allCases) { type in
                                Text(type.rawValue.capitalized).tag(type)
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
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

            ZStack {
                if clockType == .digital {
                    DigitalClockView(currentTime: currentTime)
                } else if clockType == .analog {
                    AnalogClockView(currentTime: currentTime)
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
        }
        .onHover(perform: { isHovering in
            self.isHovering = isHovering
        })
        .onReceive(timer) { input in
            self.currentTime = input
        }
    }
}

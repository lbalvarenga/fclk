//
//  DigitalClockView.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct ClockFace: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            ForEach(0..<12) { hour in
                let isMajorHour = hour % 3 == 0
                let tickWidth = size * (isMajorHour ? 0.015 : 0.007)
                let tickHeight = size * (isMajorHour ? 0.05 : 0.025)

                Capsule()
                    .fill(Color.primary)
                    .frame(width: tickWidth, height: tickHeight)
                    .offset(y: (size / 2) * 0.85)
                    .rotationEffect(.degrees(Double(hour) * 30))
            }
        }
    }
}

struct ClockHand: View {
    var length: CGFloat
    var width: CGFloat
    var color: Color

    var body: some View {
        Capsule()
            .fill(color)
            .frame(width: width, height: length)
            .offset(y: -length / 2)
    }
}

struct AnalogClockView: View {
    @ObservedObject var settingsStore = SettingsStore.shared

    let currentTime: Date

    // Animation 59s->0 CC wraparound fix
    @State private var revolutions: Int = 0
    @State private var secondsAngle: Angle

    init(currentTime: Date) {
        self.currentTime = currentTime

        // Initialize secondsAngle based on the current time
        let second = Double(
            Calendar.current.component(.second, from: currentTime)
        )
        self.secondsAngle = .degrees((second / 60.0 * 360.0))
    }

    var body: some View {
        GeometryReader { geometry in
            let date = currentTime
            let size = min(geometry.size.width, geometry.size.height)

            ZStack {
                ClockFace(size: size)

                let hourHandLength = size * 0.25
                let minuteHandLength = size * 0.38
                let secondHandLength = size * 0.42

                ClockHand(
                    length: hourHandLength,
                    width: size * 0.025,
                    color: .primary
                )
                .rotationEffect(calcHourAngle(for: date))
                .shadow(radius: 3)

                ClockHand(
                    length: minuteHandLength,
                    width: size * 0.018,
                    color: .primary
                )
                .rotationEffect(calcMinuteAngle(for: date))
                .shadow(radius: 3)

                if settingsStore.settings.ACShowSecondsHand {
                    ClockHand(
                        length: secondHandLength,
                        width: size * 0.007,
                        color: .red
                    )
                    .rotationEffect(secondsAngle)
                    .shadow(radius: 3)
                    .animation(
                        settingsStore.settings.ACSmoothHands
                            ? .linear(duration: 1) : nil,
                        value: secondsAngle
                    )
                }

                ZStack {
                    Circle().fill(Color.primary).frame(
                        width: size * 0.05,
                        height: size * 0.05
                    )

                    if settingsStore.settings.ACShowSecondsHand {
                        Circle().fill(Color.red).frame(
                            width: size * 0.035,
                            height: size * 0.035
                        )
                    }

                    Circle().fill(Color.primary).frame(
                        width: size * 0.01,
                        height: size * 0.01
                    )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onChange(of: currentTime) { prev, curr in
                if Calendar.current.component(.second, from: prev)
                    > Calendar.current.component(.second, from: curr)
                {
                    revolutions += 1
                }

                secondsAngle = calcSecondAngle(for: date)
            }

        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func calcHourAngle(for date: Date) -> Angle {
        let calendar = Calendar.current
        let hour = Double(calendar.component(.hour, from: date) % 12)
        let minute = Double(calendar.component(.minute, from: date))
        let totalHours = hour + (minute / 60)
        return .degrees(totalHours / 12 * 360)
    }

    private func calcMinuteAngle(for date: Date) -> Angle {
        let calendar = Calendar.current
        let minute = Double(calendar.component(.minute, from: date))
        let second = Double(calendar.component(.second, from: date))
        let totalMinutes = minute + (second / 60)
        return .degrees(totalMinutes / 60 * 360)
    }

    private func calcSecondAngle(for date: Date) -> Angle {
        let second = Double(Calendar.current.component(.second, from: date))
        return .degrees(((second + 1) / 60.0 * 360.0))
            + .degrees(Double(revolutions) * 360.0)
    }
}

#if DEBUG
    //    #Preview {
    //        let settingsStore = SettingsStore.shared
    //        BaseClockView(settingsStore: settingsStore)
    //    }
#endif

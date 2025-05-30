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
                .rotationEffect(hourAngle(for: date))
                .shadow(radius: 3)

                ClockHand(
                    length: minuteHandLength,
                    width: size * 0.018,
                    color: .primary
                )
                .rotationEffect(minuteAngle(for: date))
                .shadow(radius: 3)

                if settingsStore.settings.ACShowSecondsHand {
                    ClockHand(
                        length: secondHandLength,
                        width: size * 0.007,
                        color: .red
                    )
                    .rotationEffect(secondAngle(for: date, smooth: settingsStore.settings.ACSmoothHands))
                    .shadow(radius: 3)
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
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func hourAngle(for date: Date) -> Angle {
        let calendar = Calendar.current
        let hour = Double(calendar.component(.hour, from: date) % 12)
        let minute = Double(calendar.component(.minute, from: date))
        let totalHours = hour + (minute / 60)
        return .degrees(totalHours / 12 * 360)
    }

    private func minuteAngle(for date: Date) -> Angle {
        let calendar = Calendar.current
        let minute = Double(calendar.component(.minute, from: date))
        let second = Double(calendar.component(.second, from: date))
        let totalMinutes = minute + (second / 60)
        return .degrees(totalMinutes / 60 * 360)
    }

    private func secondAngle(for date: Date, smooth: Bool) -> Angle {
        let calendar = Calendar.current
        let second = Double(calendar.component(.second, from: date))

        if smooth {
            let nanosecond = Double(calendar.component(.nanosecond, from: date))
            let totalSeconds = second + (nanosecond / 1_000_000_000)
            return .degrees(totalSeconds / 60 * 360 - 90)  // -90 to align 0/60 at the top
        } else {
            // For ticking, only use the whole second
            return .degrees(second / 60 * 360 - 90)  // -90 to align 0/60 at the top
        }
    }
}

#if DEBUG
//    #Preview {
//        let settingsStore = SettingsStore.shared
//        BaseClockView(settingsStore: settingsStore)
//    }
#endif

//
//  DigitalClockView.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct ClockFace: View {
    var body: some View {
        ZStack {
            // Using 12 tick marks for a cleaner, minimalist look
            ForEach(0..<12) { hour in
                // The main hours (12, 3, 6, 9) are thicker
                let isMajorHour = hour % 3 == 0
                Capsule()
                    .fill(Color.primary)
                    .frame(
                        width: isMajorHour ? 4 : 2,
                        height: isMajorHour ? 15 : 7
                    )
                    .offset(y: 125)
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
    let currentTime: Date

    var body: some View {
        ZStack {
            ClockFace()

            // Hour Hand
            ClockHand(length: 65, width: 6, color: .primary)
                .rotationEffect(hourAngle)

            // Minute Hand
            ClockHand(length: 100, width: 4, color: .primary)
                .rotationEffect(minuteAngle)

            // Second Hand
            ClockHand(length: 110, width: 2, color: .red)
                .rotationEffect(secondAngle)

            // Center circle
            Circle()
                .fill(Color.red)
                .frame(width: 10, height: 10)
        }
    }

    private var hourAngle: Angle {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentTime)
        let minute = calendar.component(.minute, from: currentTime)
        let totalHours = Double(hour % 12) + Double(minute) / 60
        return .degrees(totalHours * 30)
    }

    private var minuteAngle: Angle {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: currentTime)
        let second = calendar.component(.second, from: currentTime)
        let totalMinutes = Double(minute) + Double(second) / 60
        return .degrees(totalMinutes * 6)
    }

    private var secondAngle: Angle {
        let calendar = Calendar.current
        let second = calendar.component(.second, from: currentTime)
        return .degrees(Double(second) * 6)
    }
}

//
//  ClockType.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

enum ClockType: String, CaseIterable, Identifiable {
    case digital, analog, pomodoro
    var id: Self { self }
}

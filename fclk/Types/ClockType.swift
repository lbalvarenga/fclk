//
//  ClockType.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

enum ClockType: String, CaseIterable, Identifiable, Codable {
    case digital, analog, pomo
    var id: Self { self }
}

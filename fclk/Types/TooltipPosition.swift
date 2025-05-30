//
//  TooltipPosition.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

enum TooltipPosition: String, CaseIterable, Identifiable, Codable {
    case top
    case bottom
    case hidden
    var id: Self { self }
}

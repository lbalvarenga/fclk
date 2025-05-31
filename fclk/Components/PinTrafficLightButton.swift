//
//  PinTrafficLightButton.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct PinTrafficLightButton: View {
    var engaged: Bool = false
    var action: () -> Void

    var body: some View {
        CircularButtonView(
            engaged: engaged,
            action: action,
            baseColor: .blue,
            engagedColor: .cyan,
            defaultColor: Color.gray.opacity(0.5),
            iconName: "pin",
            iconHoverColor: Color.black.opacity(0.6),
            iconDefaultColor: Color.clear
        )
    }
}

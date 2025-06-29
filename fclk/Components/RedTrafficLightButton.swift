//
//  RedTrafficLightButton.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct RedTrafficLightButton: View {
    var engaged: Bool = false
    var action: () -> Void

    var body: some View {
        CircularButtonView(
            engaged: engaged,
            action: action,
            baseColor: .red,
            engagedColor: .red,
            defaultColor: Color.gray.opacity(0.5),
            iconName: "xmark",
            iconHoverColor: Color.black.opacity(0.6),
            iconDefaultColor: Color.clear  // Original behavior: icon only appears on hover
        )
    }
}

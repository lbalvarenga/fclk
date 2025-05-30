//
//  RedTrafficLightButton.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct RedTrafficLightButton: View {
    @State private var isHovering = false
    @State private var isPressed = false

    var engaged: Bool = false  // Optional state to indicate if the button is engaged

    var action: () -> Void

    var body: some View {
        Circle()
            .fill(
                isPressed
                    ? Color.red.opacity(0.7)
                    : (isHovering
                        ? Color.red.opacity(0.9)
                        : (engaged ? Color.red : Color.gray.opacity(0.5)))
            )
            .frame(width: 12, height: 12)
            .overlay(
                Image(systemName: "xmark")
                    .font(.system(size: 7, weight: .black))
                    .foregroundColor(
                        isHovering ? Color.black.opacity(0.6) : Color.clear
                    )  // Symbol appears on hover
            )
            .onHover { hovering in
                isHovering = hovering
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if isHovering {  // Only show pressed state if hovering
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        if isPressed {
                            action()
                        }
                        isPressed = false
                    }
            )
            .animation(.easeInOut(duration: 0.1), value: isHovering)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .animation(.easeInOut(duration: 0.1), value: engaged)
    }
}

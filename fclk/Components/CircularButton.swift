//
//  CircularButton.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct CircularButtonView: View {
    @State private var isHovering = false
    @State private var isPressed = false

    var engaged: Bool
    var action: () -> Void
    var baseColor: Color
    var engagedColor: Color
    var defaultColor: Color
    var iconName: String
    var iconSize: CGFloat = 7
    var iconWeight: Font.Weight = .black
    var iconHoverColor: Color
    var iconDefaultColor: Color  // Color for the icon when not hovering (can be clear or a persistent color)

    var body: some View {
        Circle()
            .fill(
                isPressed
                    ? baseColor.opacity(0.7)
                    : (isHovering
                        ? baseColor.opacity(0.9)
                        : (engaged ? engagedColor : defaultColor))
            )
            .frame(width: 12, height: 12)
            .overlay(
                Image(systemName: iconName)
                    .font(.system(size: iconSize, weight: iconWeight))
                    .foregroundColor(
                        isHovering ? iconHoverColor : iconDefaultColor
                    )
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

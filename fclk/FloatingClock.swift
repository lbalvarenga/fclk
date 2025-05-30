//
//  fclkApp.swift
//  fclk
//
//  Created by Lucas Alvarenga on 29/05/25.
//

import AppKit
import SwiftUI

@main
struct FloatingClock: App {
    @ObservedObject var settingsStore = SettingsStore.shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            BaseClockView()
                .onAppear {
                    if appDelegate.window == nil {
                        appDelegate.window = NSApplication.shared.keyWindow
                        appDelegate.setupWindow()
                    }
                }
        }
        .commands {
            CommandGroup(replacing: .newItem) {}  // Gets rid of File
            CommandGroup(replacing: .undoRedo) {}  // Gets rid of Edit (1/2)
            CommandGroup(replacing: .pasteboard) {}  // Gets rid of Edit (2/2)

            CommandMenu("Edit") {
                Picker(
                    "Clock Type",
                    selection: $settingsStore.settings.clockType
                ) {
                    ForEach(
                        Array(ClockType.allCases.enumerated()),
                        id: \.element.rawValue
                    ) { i, type in
                        Text(type.rawValue.capitalized).tag(type)
                            .keyboardShortcut(
                                KeyEquivalent(Character("\(i + 1)")),
                                modifiers: [.command]
                            )
                    }
                }

                Picker(
                    "Tooltip Position",
                    selection: $settingsStore.settings.tooltipPosition
                ) {
                    ForEach(
                        Array(TooltipPosition.allCases.enumerated()),
                        id: \.element.rawValue
                    ) { i, type in
                        Text(type.rawValue.capitalized).tag(type)
                            .keyboardShortcut(
                                KeyEquivalent(Character("\(i + 1)")),
                                modifiers: [.shift, .option]
                            )
                    }
                }
            }

            CommandGroup(replacing: .toolbar) {
                Toggle(
                    "Always on Top",
                    isOn: $settingsStore.settings.alwaysOnTop
                )
                .keyboardShortcut("f", modifiers: [.command])

                Divider()

                Button("Increase Size") {
                    resizeWindow(
                        by: 1.0 + settingsStore.settings.resizePercentage
                    )

                }
                .keyboardShortcut("+", modifiers: [.command])

                Button("Decrease Size") {
                    resizeWindow(
                        by: 1.0 - settingsStore.settings.resizePercentage
                    )

                }
                .keyboardShortcut("-", modifiers: [.command])

                Divider()
            }
        }

        #if os(macOS)
            Settings {
                SettingsView()
            }
        #endif
    }

    private func resizeWindow(by factor: CGFloat) {
        guard let window = appDelegate.window else { return }

        let currentFrame = window.frame
        let currentSize = currentFrame.size

        let newWidth = currentSize.width * factor
        let newHeight = currentSize.height * factor

        // Optional: Add minimum size constraints
        let minSize: CGFloat = 50.0
        guard newWidth >= minSize && newHeight >= minSize else {
            // Optionally, set to minimum size or just prevent resize
            // For example, clamp to minSize if it goes below
            // let clampedWidth = max(newWidth, minSize)
            // let clampedHeight = max(newHeight, minSize)
            // if currentSize.width == clampedWidth && currentSize.height == clampedHeight { return }
            // ... then use clampedWidth/Height below
            return  // Or handle as appropriate
        }

        // Calculate new origin to keep the window centered
        let newOriginX =
            currentFrame.origin.x + (currentSize.width - newWidth) / 2
        let newOriginY =
            currentFrame.origin.y + (currentSize.height - newHeight) / 2

        let newFrame = NSRect(
            x: newOriginX,
            y: newOriginY,
            width: newWidth,
            height: newHeight
        )

        window.setFrame(newFrame, display: true, animate: true)
    }
}

#if DEBUG
    #Preview {
        BaseClockView(settingsStore: SettingsStore())
    }
#endif

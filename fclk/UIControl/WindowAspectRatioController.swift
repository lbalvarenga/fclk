//
//  WindowAspectRatioController.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import AppKit
import SwiftUI

struct WindowAspectRatioController: NSViewRepresentable {
    @ObservedObject var settingsStore = SettingsStore.shared

    // Coordinator class to hold state across updates
    class Coordinator: NSObject {
        var previousClockType: ClockType = .analog  // Default, will be set by makeNSView
    }

    // Coordinator to store the previous state for accurate transition detection
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        // Set the initial state in the coordinator based on the settingsStore at makeNSView time.
        // This helps in correctly detecting the first transition to a locked state.
        context.coordinator.previousClockType =
            settingsStore.settings.clockType

        DispatchQueue.main.async {
            if let window = view.window {
                // Initial application of settings
                self.applyWindowSettings(for: window, context: context)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        if let window = nsView.window {
            self.applyWindowSettings(for: window, context: context)
        }
    }

    private func applyWindowSettings(for window: NSWindow, context: Context) {
        if window.inLiveResize {
            return
        }

        let currentClockType = settingsStore.settings.clockType

        switch settingsStore.settings.clockType {
        case .analog:
            if let contentView = window.contentView {
                let currentContentFrame = contentView.frame
                let toolbarHeight: CGFloat = 55.0

                if currentContentFrame.width > 0 {
                    let newClockSide = currentContentFrame.width  // Clock display width and height
                    let desiredTotalContentHeight = newClockSide + toolbarHeight

                    // Set the contentAspectRatio to guide user resizes for the analog clock state
                    let desiredContentAR = CGSize(
                        width: newClockSide,
                        height: desiredTotalContentHeight
                    )
                    if window.contentAspectRatio != desiredContentAR {
                        window.contentAspectRatio = desiredContentAR
                    }

                    let currentActualClockDisplayHeight =
                        currentContentFrame.height - toolbarHeight
                    let isShapeCorrect =
                        abs(currentActualClockDisplayHeight - newClockSide)
                        < 0.01
                        && abs(
                            currentContentFrame.height
                                - desiredTotalContentHeight
                        ) < 0.01

                    let justLockedToAnalog =
                        (context.coordinator.previousClockType == .analog)
                        && currentClockType == .analog

                    if !isShapeCorrect || justLockedToAnalog {
                        let newContentSize = CGSize(
                            width: newClockSide,
                            height: desiredTotalContentHeight
                        )
                        let requiredWindowSizeForNewContent = window.frameRect(
                            forContentRect: NSRect(
                                origin: .zero,
                                size: newContentSize
                            )
                        ).size
                        var newFinalWindowFrame = window.frame
                        let oldCenterPoint = CGPoint(
                            x: newFinalWindowFrame.midX,
                            y: newFinalWindowFrame.midY
                        )

                        newFinalWindowFrame.size =
                            requiredWindowSizeForNewContent
                        newFinalWindowFrame.origin.x =
                            oldCenterPoint.x - newFinalWindowFrame.size.width
                            / 2.0
                        newFinalWindowFrame.origin.y =
                            oldCenterPoint.y - newFinalWindowFrame.size.height
                            / 2.0

                        if newFinalWindowFrame.width > 0
                            && newFinalWindowFrame.height > 0
                            && window.styleMask.contains(.resizable)
                            && !window.isMiniaturized
                        {
                            let frameToSet = newFinalWindowFrame
                            DispatchQueue.main.async {
                                guard
                                    window.isVisible && window.windowNumber > 0
                                else { return }
                                if window.frame != frameToSet {
                                    window.setFrame(
                                        frameToSet,
                                        display: true,
                                        animate: true
                                    )
                                }
                            }
                        }
                    }
                }
            }
            break
        default:
            if window.contentAspectRatio != .zero {
                window.contentAspectRatio = .zero
            }
            if window.resizeIncrements != NSSize(width: 1.0, height: 1.0) {
                window.resizeIncrements = NSSize(width: 1.0, height: 1.0)
            }
            break
        }

        context.coordinator.previousClockType = currentClockType
    }
}

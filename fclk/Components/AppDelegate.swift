//
//  AppDelegate.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            self.window = window
            setupWindow()
        }
    }

    func setupWindow() {
        guard let window = window else { return }

        window.styleMask = [.borderless, .fullSizeContentView, .resizable]
        window.level = .floating
        window.isMovableByWindowBackground = true

        window.isOpaque = false
        window.backgroundColor = .clear
    }

    func applicationShouldTerminateAfterLastWindowClosed(
        _ sender: NSApplication
    ) -> Bool {
        return true
    }
}

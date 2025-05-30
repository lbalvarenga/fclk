//
//  AppDelegate.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import AppKit
import Combine
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow?
    @ObservedObject var settingsStore = SettingsStore.shared
    private var cancellables = Set<AnyCancellable>()

    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            self.window = window
            setupWindow()
            observeAOTPreference()
        }
    }

    func setupWindow() {
        guard let window = window else { return }

        window.styleMask = [.borderless, .fullSizeContentView, .resizable]
        updateWindowAlwaysOnTop(
            isAlwaysOnTop: settingsStore.settings.alwaysOnTop
        )
        window.isMovableByWindowBackground = true

        window.isOpaque = false
        window.backgroundColor = .clear
    }

    func updateWindowAlwaysOnTop(isAlwaysOnTop: Bool) {
        guard let window = window else { return }

        if isAlwaysOnTop {
            window.level = .floating
        } else {
            window.level = .normal
        }
    }

    func observeAOTPreference() {
        settingsStore.$settings
            .map(\.alwaysOnTop)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)  // Ensure sink runs on the main thread
            .sink { [weak self] newAlwaysOnTopValue in
                self?.updateWindowAlwaysOnTop(
                    isAlwaysOnTop: newAlwaysOnTopValue
                )
            }
            .store(in: &cancellables)
    }

    func applicationShouldTerminateAfterLastWindowClosed(
        _ sender: NSApplication
    ) -> Bool {
        return true
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        // When the app becomes active (e.g., clicking Dock icon),
        // ensure the window comes to the front.
        self.window?.makeKeyAndOrderFront(nil)
    }
}

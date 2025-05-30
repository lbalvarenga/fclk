//
//  fclkApp.swift
//  fclk
//
//  Created by Lucas Alvarenga on 29/05/25.
//

import AppKit
import SwiftUI

@main
struct fclkApp: App {
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
            CommandGroup(replacing: .newItem) {} // Gets rid of File
            CommandGroup(replacing: .undoRedo) {} // Gets rid of Edit (1/2)
            CommandGroup(replacing: .pasteboard) {} // Gets rid of Edit (2/2)
        }
    }
}

#Preview {
    BaseClockView()
}

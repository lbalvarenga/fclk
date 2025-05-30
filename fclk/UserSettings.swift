//
//  UserSettings.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import Foundation
import Combine

struct UserSettings: Codable {
    var clockType: ClockType
    var alwaysOnTop: Bool
    var tooltipPosition: TooltipPosition
    
    // Digital Clock
    var DCUse24HourClock: Bool
    var DCShowSeconds: Bool
    
    // Analog Clock
    var ACSmoothHands: Bool
    var ACShowSecondsHand: Bool

    static func defaultSettings() -> UserSettings {
        return UserSettings(
            clockType: .digital,
            alwaysOnTop: true,
            tooltipPosition: .top,
            DCUse24HourClock: false,
            DCShowSeconds: false,
            ACSmoothHands: true,
            ACShowSecondsHand: true
        )
    }
}

class SettingsManager {
    static let shared = SettingsManager()

    private let settingsURL: URL

    private init() {
        do {
            let documentsDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )

            self.settingsURL = documentsDirectory.appendingPathComponent(
                "userSettings.plist"
            )
        } catch {
            fatalError("Could not access documents directory: \(error)")
        }
    }

    func save(settings: UserSettings) {
        do {
            let data = try PropertyListEncoder().encode(settings)
            try data.write(to: settingsURL)
        } catch {
            print("Error saving settings: \(error)")
        }
    }

    func load() -> UserSettings {
        guard let data = try? Data(contentsOf: settingsURL) else {
            return UserSettings.defaultSettings()
        }

        let decoder = PropertyListDecoder()

        do {
            let settings = try decoder.decode(UserSettings.self, from: data)
            return settings
        } catch {
            print("Error loading settings: \(error)")
            return UserSettings.defaultSettings()
        }
    }
}

class SettingsStore: ObservableObject {
    @Published var settings: UserSettings

    private var cancellable: AnyCancellable?

    init() {
        self.settings = SettingsManager.shared.load()

        cancellable =
            $settings
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { newSettings in
                SettingsManager.shared.save(settings: newSettings)
                print("Settings saved: \(newSettings)")
            }
    }
}

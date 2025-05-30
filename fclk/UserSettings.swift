//
//  UserSettings.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import Combine
import Foundation

struct UserSettings: Codable {
    var clockType: ClockType
    var alwaysOnTop: Bool
    var tooltipPosition: TooltipPosition
    var resizePercentage: CGFloat

    // Digital Clock
    var DCUse24HourClock: Bool
    var DCShowSeconds: Bool
    var DCFormatString: String {
        if DCUse24HourClock {
            return DCShowSeconds ? "HH:mm:ss" : "HH:mm"
        } else {
            return DCShowSeconds ? "hh:mm:ss a" : "hh:mm a"
        }
    }
    var DCFont: String
    var DCFontPadding: CGSize

    // Analog Clock
    var ACSmoothHands: Bool
    var ACShowSecondsHand: Bool

    static func defaultSettings() -> UserSettings {
        return UserSettings(
            clockType: .digital,
            alwaysOnTop: true,
            tooltipPosition: .top,
            resizePercentage: 0.1,
            DCUse24HourClock: false,
            DCShowSeconds: false,
            DCFont: "Helvetica Neue",
            DCFontPadding: CGSize(width: 10, height: 10),
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
    static let shared = SettingsStore()
    @Published var settings: UserSettings

    private var cancellable: AnyCancellable?

    init() {
        self.settings = SettingsManager.shared.load()

        cancellable =
            $settings
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { newSettings in
                SettingsManager.shared.save(settings: newSettings)
                //                print("Settings saved: \(newSettings)")
            }
    }
}

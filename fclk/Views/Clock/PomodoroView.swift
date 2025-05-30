//
//  DigitalClockView.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct PomodoroView: View {
    var body: some View {
        VStack {
            Image(systemName: "wrench.and.screwdriver")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
            Text("In Construction")
                .font(.system(size: 500, weight: .bold))
                .minimumScaleFactor(0.001)
                .lineLimit(1)
        }
    }
}

#if DEBUG
    #Preview {
        BaseClockView()
            .environmentObject(SettingsStore())
    }
#endif

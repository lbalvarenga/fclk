//
//  DigitalClockView.swift
//  fclk
//
//  Created by Lucas Alvarenga on 30/05/25.
//

import SwiftUI

struct DigitalClockView: View {
    let currentTime: Date
    
    var body: some View {
        Text(currentTime, style: .time)
            .font(.system(size: 500, weight: .bold))
            .minimumScaleFactor(0.001)
            .lineLimit(1)
    }
}

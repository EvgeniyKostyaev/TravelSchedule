//
//  LaunchScreenView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 06.02.2026.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        Image(.splashScreen)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

#Preview {
    LaunchScreenView()
}

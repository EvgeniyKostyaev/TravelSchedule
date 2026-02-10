//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 10.02.2026.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ErrorStateView(errorState: .noInternet)
    }
}

#Preview {
    SettingsView()
}

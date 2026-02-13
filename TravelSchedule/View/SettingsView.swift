//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 10.02.2026.
//

import SwiftUI

struct SettingsView: View {
    @State private var errorState: ErrorState = .noInternet
    
    var body: some View {
        ErrorStateView(errorState: errorState)
            .onTapGesture {
                errorState = errorState == .noInternet ? .serverError : .noInternet
            }
    }
}

#Preview {
    SettingsView()
}

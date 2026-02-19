//
//  MainView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 29.01.2026.
//

import SwiftUI

enum Tab: Int {
    case schedule
    case settings
}

struct MainView: View {
    @StateObject private var viewModel: MainViewModel = MainViewModel()
    @StateObject private var settingsViewModel: SettingsViewModel = SettingsViewModel()
    
    var body: some View {
        Group {
            switch viewModel.selectedTab {
            case .schedule:
                ScheduleView()
            case .settings:
                SettingsView(viewModel: settingsViewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
            BottomTabBarView(
                selectedTab: Binding(
                    get: { viewModel.selectedTab },
                    set: { selectedTab in
                        viewModel.onUpdateSelectedTab(selectedTab)
                    }
                )
            )
        }
        .ignoresSafeArea(.keyboard)
        .preferredColorScheme(settingsViewModel.isDarkThemeEnabled ? .dark : .light)
    }
}

#Preview {
    MainView()
}

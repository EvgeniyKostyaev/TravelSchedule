//
//  MainViewModel.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 19.02.2026.
//

import Foundation

@MainActor
final class MainViewModel: ObservableObject {
    @Published private(set) var selectedTab: Tab = .schedule

    func onUpdateSelectedTab(_ tab: Tab) {
        selectedTab = tab
    }
}

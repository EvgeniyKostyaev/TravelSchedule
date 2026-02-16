//
//  SettingsViewModel.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 13.02.2026.
//

import Foundation
import Observation
import Combine

@Observable
final class SettingsViewModel {
    enum Action {
        case load
        case toggleDarkTheme(Bool)
    }

    private enum Constants {
        static let darkThemeKey: String = "isDarkThemeEnabled"
    }

    var isDarkThemeEnabled: Bool = false

    private let userDefaults: UserDefaults
    private let actions = PassthroughSubject<Action, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        bindActions()
        send(.load)
    }

    func send(_ action: Action) {
        actions.send(action)
    }

    func loadThemePreference() {
        isDarkThemeEnabled = userDefaults.bool(forKey: Constants.darkThemeKey)
    }

    func saveThemePreference() {
        userDefaults.set(isDarkThemeEnabled, forKey: Constants.darkThemeKey)
    }

    private func bindActions() {
        actions
            .sink { [weak self] action in
                self?.handle(action)
            }
            .store(in: &cancellables)
    }

    private func handle(_ action: Action) {
        switch action {
        case .load:
            loadThemePreference()
        case .toggleDarkTheme(let isEnabled):
            isDarkThemeEnabled = isEnabled
            saveThemePreference()
        }
    }
}

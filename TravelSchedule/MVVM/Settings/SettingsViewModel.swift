//
//  SettingsViewModel.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 13.02.2026.
//

import Foundation
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    enum Action {
        case load
        case toggleDarkTheme(Bool)
    }
    
    private enum Constants {
        static let darkThemeKey: String = "isDarkThemeEnabled"
    }
    
    @Published var isAgreementPresented: Bool = false
    
    @Published private(set) var isDarkThemeEnabled: Bool = false
    @Published private(set) var copyrightText: String = String()
    @Published private(set) var isLoading: Bool = false
    
    private let userDefaults: UserDefaults
    private let dataProvider: SettingsDataProviderProtocol
    private let actions = PassthroughSubject<Action, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(userDefaults: UserDefaults = .standard,
         dataProvider: SettingsDataProviderProtocol = SettingsDataProvider.shared) {
        self.userDefaults = userDefaults
        self.dataProvider = dataProvider
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
    
    func load() async {
        guard copyrightText.isEmpty else {
            return
        }
        
        isLoading = true
        
        do {
            let payload = try await dataProvider.fetchSettingsPayload()
            copyrightText = payload.text
        } catch {
            print(error.networkErrorKind)
            copyrightText = String()
        }
        
        isLoading = false
    }
    
    func showUserAgreement() {
        isAgreementPresented = true
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

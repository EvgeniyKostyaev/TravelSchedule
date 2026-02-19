//
//  SettingsViewModel.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 13.02.2026.
//

import Foundation

private enum Constants {
    static let darkThemeKey: String = "isDarkThemeEnabled"
}

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published private(set) var isAgreementPresented: Bool = false
    @Published private(set) var isDarkThemeEnabled: Bool = false
    @Published private(set) var copyrightText: String = String()
    @Published private(set) var isLoading: Bool = false
    
    private let userDefaults: UserDefaults
    private let dataProvider: SettingsDataProviderProtocol
    
    init(userDefaults: UserDefaults = .standard,
         dataProvider: SettingsDataProviderProtocol = SettingsDataProvider.shared) {
        self.userDefaults = userDefaults
        self.dataProvider = dataProvider
        
        loadThemePreference()
    }
    
    func onUpdateDarkThemeEnabled(isDarkThemeEnabled: Bool) {
        self.isDarkThemeEnabled = isDarkThemeEnabled
        
        saveThemePreference()
    }
    
    func showUserAgreement() {
        isAgreementPresented = true
    }
    
    func onUpdateAgreementPresented(isAgreementPresented: Bool) {
        self.isAgreementPresented = isAgreementPresented
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
    
    // MARK: - Private methods
    private func loadThemePreference() {
        isDarkThemeEnabled = userDefaults.bool(forKey: Constants.darkThemeKey)
    }
    
    private func saveThemePreference() {
        userDefaults.set(isDarkThemeEnabled, forKey: Constants.darkThemeKey)
    }
}

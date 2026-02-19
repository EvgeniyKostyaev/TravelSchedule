//
//  SettingsDataProvider.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 18.02.2026.
//

import Foundation

struct SettingsPayload: Sendable {
    let text: String
}

protocol SettingsDataProviderProtocol: Sendable {
    func fetchSettingsPayload() async throws -> SettingsPayload
}

actor SettingsDataProvider: SettingsDataProviderProtocol {
    static let shared = SettingsDataProvider()

    private let copyrightService: CopyrightServiceProtocol
    private var cachedPayload: SettingsPayload?

    init(copyrightService: CopyrightServiceProtocol = NetworkClientFactory.shared.makeCopyrightService()) {
        self.copyrightService = copyrightService
    }

    func fetchSettingsPayload() async throws -> SettingsPayload {
        if let cachedPayload {
            return cachedPayload
        }

        let copyrightData = try await copyrightService.getScheduleBannersData()

        let payload = SettingsPayload(text: copyrightData.copyright?.text ?? String())
        cachedPayload = payload

        return payload
    }
}

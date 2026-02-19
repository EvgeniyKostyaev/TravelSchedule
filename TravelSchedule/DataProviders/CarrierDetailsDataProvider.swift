//
//  CarrierDetailsDataProvider.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 18.02.2026.
//

import Foundation

struct CarrierDetailsPayload: Sendable {
    let name: String
    let logoURL: URL?
    let email: String
    let phone: String
}

protocol CarrierDetailsDataProviderProtocol: Sendable {
    func fetchCarrierDetails(code: String, system: String?) async throws -> CarrierDetailsPayload?
}

actor CarrierDetailsDataProvider: CarrierDetailsDataProviderProtocol {
    static let shared = CarrierDetailsDataProvider()

    private let carrierService: CarrierServiceProtocol

    init(carrierService: CarrierServiceProtocol = NetworkClientFactory.shared.makeCarrierService()) {
        self.carrierService = carrierService
    }

    func fetchCarrierDetails(code: String, system: String?) async throws -> CarrierDetailsPayload? {
        let response = try await carrierService.getCarrierInfo(
            code: code,
            system: system,
            lang: "ru_RU",
            format: "json"
        )

        guard let carrier = response.carriers?.first else {
            return nil
        }

        return CarrierDetailsPayload(
            name: carrier.title ?? String(),
            logoURL: URL(string: carrier.logo ?? String()),
            email: carrier.email ?? String(),
            phone: carrier.phone ?? String()
        )
    }
}

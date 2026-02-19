//
//  CarriersListDataProvider.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 18.02.2026.
//

import Foundation

protocol CarriersListDataProviderProtocol: Sendable {
    func fetchCarrierOptions(
        fromCode: String,
        toCode: String
    ) async throws -> [CarrierOption]
}

actor CarriersListDataProvider: CarriersListDataProviderProtocol {
    static let shared = CarriersListDataProvider()

    private let searchService: SearchServiceProtocol
    private let mapper: CarriersListMapper

    init(
        searchService: SearchServiceProtocol = NetworkClientFactory.shared.makeSearchService(),
        mapper: CarriersListMapper = CarriersListMapper()
    ) {
        self.searchService = searchService
        self.mapper = mapper
    }

    func fetchCarrierOptions(
        fromCode: String,
        toCode: String
    ) async throws -> [CarrierOption] {
        let schedules = try await searchService.getScheduleBetweenStations(from: fromCode, to: toCode)
        return mapper.map(segments: schedules.segments ?? [])
    }
}

//
//  CityStationSelectionDataProvider.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 13.02.2026.
//

import Foundation

struct StationSelectionOption: Hashable, Sendable {
    let title: String
    let code: String
}

struct CityStationsPayload: Sendable {
    let cities: [String]
    let stationsByCity: [String: [StationSelectionOption]]
}

protocol CityStationSelectionDataProviderProtocol: Sendable {
    func fetchCityStationsPayload() async throws -> CityStationsPayload
}

actor CityStationSelectionDataProvider: CityStationSelectionDataProviderProtocol {
    static let shared = CityStationSelectionDataProvider()

    private let stationsListService: StationsListServiceProtocol
    private let mapper: CityStationSelectionMapper
    private var cachedPayload: CityStationsPayload?

    init(
        stationsListService: StationsListServiceProtocol = NetworkClientFactory.shared.makeStationsListService(),
        mapper: CityStationSelectionMapper = CityStationSelectionMapper()
    ) {
        self.stationsListService = stationsListService
        self.mapper = mapper
    }

    func fetchCityStationsPayload() async throws -> CityStationsPayload {
        if let cachedPayload {
            return cachedPayload
        }

        let rawData = try await stationsListService.getAllStationsRawData()
        let payload = try mapper.map(rawData: rawData)
        cachedPayload = payload
        return payload
    }
}

//
//  CityStationSelectionNetworkClient.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 13.02.2026.
//

import Foundation

struct CityStationsPayload: Sendable {
    let cities: [String]
    let stationsByCity: [String: [String]]
}

protocol CityStationSelectionDataProviderProtocol: Sendable {
    func fetchCityStationsPayload() async throws -> CityStationsPayload
}

actor CityStationSelectionDataProvider: CityStationSelectionDataProviderProtocol {
    static let shared = CityStationSelectionDataProvider()

    private let stationsListService: StationsListServiceProtocol
    private var cachedPayload: CityStationsPayload?

    init(stationsListService: StationsListServiceProtocol = NetworkClientFactory.shared.makeStationsListService()) {
        self.stationsListService = stationsListService
    }

    func fetchCityStationsPayload() async throws -> CityStationsPayload {
        if let cachedPayload {
            return cachedPayload
        }

        let allStations = try await stationsListService.getAllStations()

        var stationsByCity: [String: [String]] = [:]

        for country in allStations.countries ?? [] {
            for region in country.regions ?? [] {
                for settlement in region.settlements ?? [] {
                    guard let cityName = settlement.title?.trimmingCharacters(in: .whitespacesAndNewlines),
                          !cityName.isEmpty else {
                        continue
                    }

                    let stationTitles = (settlement.stations ?? [])
                        .compactMap { station in
                            station.title?.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                        .filter { !$0.isEmpty }

                    guard !stationTitles.isEmpty else {
                        continue
                    }

                    stationsByCity[cityName, default: []].append(contentsOf: stationTitles)
                }
            }
        }

        let normalizedStationsByCity = stationsByCity
            .mapValues { stations in
                Array(Set(stations)).sorted { lhs, rhs in
                    lhs.localizedCaseInsensitiveCompare(rhs) == .orderedAscending
                }
            }

        let cities = normalizedStationsByCity.keys.sorted { lhs, rhs in
            lhs.localizedCaseInsensitiveCompare(rhs) == .orderedAscending
        }

        let payload = CityStationsPayload(cities: cities, stationsByCity: normalizedStationsByCity)
        cachedPayload = payload

        return payload
    }
}

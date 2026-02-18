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
    private var cachedPayload: CityStationsPayload?

    init(stationsListService: StationsListServiceProtocol = NetworkClientFactory.shared.makeStationsListService()) {
        self.stationsListService = stationsListService
    }

    func fetchCityStationsPayload() async throws -> CityStationsPayload {
        if let cachedPayload {
            return cachedPayload
        }

        let rawData = try await stationsListService.getAllStationsRawData()
        let jsonObject = try JSONSerialization.jsonObject(with: rawData)

        guard let root = jsonObject as? [String: Any],
              let countries = root["countries"] as? [[String: Any]] else {
            return CityStationsPayload(cities: [], stationsByCity: [:])
        }

        var stationsByCity: [String: [StationSelectionOption]] = [:]

        for country in countries {
            let regions = country["regions"] as? [[String: Any]] ?? []
            for region in regions {
                let settlements = region["settlements"] as? [[String: Any]] ?? []
                for settlement in settlements {
                    guard let cityName = (settlement["title"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
                          !cityName.isEmpty else {
                        continue
                    }

                    let stations = settlement["stations"] as? [[String: Any]] ?? []
                    let stationOptions: [StationSelectionOption] = stations.compactMap { station in
                        guard let stationTitle = (station["title"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
                              !stationTitle.isEmpty else {
                            return nil
                        }

                        let stationCode = Self.extractStationCode(station: station)
                        guard !stationCode.isEmpty else {
                            return nil
                        }

                        return StationSelectionOption(title: stationTitle, code: stationCode)
                    }

                    guard !stationOptions.isEmpty else {
                        continue
                    }

                    stationsByCity[cityName, default: []].append(contentsOf: stationOptions)
                }
            }
        }

        let normalizedStationsByCity = stationsByCity.mapValues { stations in
            var uniqueByCode: [String: StationSelectionOption] = [:]
            for station in stations {
                if uniqueByCode[station.code] == nil {
                    uniqueByCode[station.code] = station
                }
            }

            return uniqueByCode.values.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        }

        let cities = normalizedStationsByCity.keys.sorted {
            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
        }

        let payload = CityStationsPayload(cities: cities, stationsByCity: normalizedStationsByCity)
        cachedPayload = payload
        return payload
    }
}

private extension CityStationSelectionDataProvider {
    static func extractStationCode(station: [String: Any]) -> String {
        if let code = (station["code"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines), !code.isEmpty {
            return code
        }

        if let codes = station["codes"] as? [String: Any] {
            if let yandexCode = (codes["yandex_code"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines), !yandexCode.isEmpty {
                return yandexCode
            }
        }

        return String()
    }
}

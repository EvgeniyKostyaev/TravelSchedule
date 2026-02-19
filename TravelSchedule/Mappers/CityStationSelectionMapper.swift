//
//  CityStationSelectionMapper.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 19.02.2026.
//

import Foundation

struct CityStationSelectionMapper: Sendable {
    func map(rawData: Data) throws -> CityStationsPayload {
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
                    guard let cityName = (settlement["title"] as? String)?
                        .trimmingCharacters(in: .whitespacesAndNewlines),
                        !cityName.isEmpty else {
                        continue
                    }

                    let stations = settlement["stations"] as? [[String: Any]] ?? []
                    let stationOptions = stations.compactMap(makeStationOption)
                    guard !stationOptions.isEmpty else {
                        continue
                    }

                    stationsByCity[cityName, default: []].append(contentsOf: stationOptions)
                }
            }
        }

        let normalizedStationsByCity = stationsByCity.mapValues(normalizeStations)
        let cities = normalizedStationsByCity.keys.sorted {
            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
        }

        return CityStationsPayload(cities: cities, stationsByCity: normalizedStationsByCity)
    }
}

private extension CityStationSelectionMapper {
    func makeStationOption(station: [String: Any]) -> StationSelectionOption? {
        guard let stationTitle = (station["title"] as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines),
            !stationTitle.isEmpty else {
            return nil
        }

        let stationCode = extractStationCode(station: station)
        guard !stationCode.isEmpty else {
            return nil
        }

        return StationSelectionOption(title: stationTitle, code: stationCode)
    }

    func normalizeStations(_ stations: [StationSelectionOption]) -> [StationSelectionOption] {
        var uniqueByCode: [String: StationSelectionOption] = [:]
        for station in stations where uniqueByCode[station.code] == nil {
            uniqueByCode[station.code] = station
        }

        return uniqueByCode.values.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }

    func extractStationCode(station: [String: Any]) -> String {
        if let code = (station["code"] as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !code.isEmpty {
            return code
        }

        if let codes = station["codes"] as? [String: Any],
           let yandexCode = (codes["yandex_code"] as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !yandexCode.isEmpty {
            return yandexCode
        }

        return String()
    }
}


//
//  StationsListViewModel.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 17.02.2026.
//

import Foundation

@MainActor
final class StationsListViewModel: ObservableObject {
    @Published private(set) var stations: [String] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorKind: NetworkErrorKind?

    private let city: String
    private let dataProvider: CityStationSelectionDataProviderProtocol

    init(
        city: String,
        dataProvider: CityStationSelectionDataProviderProtocol = CityStationSelectionDataProvider.shared
    ) {
        self.city = city
        self.dataProvider = dataProvider
    }

    func load() async {
        guard stations.isEmpty else {
            return
        }

        isLoading = true
        errorKind = nil

        do {
            let payload = try await dataProvider.fetchCityStationsPayload()
            stations = payload.stationsByCity[city] ?? []
        } catch {
            errorKind = error.networkErrorKind
        }

        isLoading = false
    }
}

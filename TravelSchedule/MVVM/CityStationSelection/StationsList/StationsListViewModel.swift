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
    @Published private(set) var errorMessage: String?

    private let city: String
    private let networkClient: CityStationSelectionDataProviderProtocol

    init(
        city: String,
        networkClient: CityStationSelectionDataProviderProtocol = CityStationSelectionDataProvider.shared
    ) {
        self.city = city
        self.networkClient = networkClient
    }

    func load() async {
        guard stations.isEmpty else {
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let payload = try await networkClient.fetchCityStationsPayload()
            stations = payload.stationsByCity[city] ?? []
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

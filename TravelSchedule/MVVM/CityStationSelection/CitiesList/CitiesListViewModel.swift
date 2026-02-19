//
//  CitiesListViewModel.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 17.02.2026.
//

import Foundation

@MainActor
final class CitiesListViewModel: ObservableObject {
    @Published private(set) var cities: [String] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorKind: NetworkErrorKind?

    private let networkClient: CityStationSelectionDataProviderProtocol

    init(networkClient: CityStationSelectionDataProviderProtocol = CityStationSelectionDataProvider.shared) {
        self.networkClient = networkClient
    }

    func load() async {
        guard cities.isEmpty else {
            return
        }

        isLoading = true
        errorKind = nil

        do {
            let payload = try await networkClient.fetchCityStationsPayload()
            cities = payload.cities
        } catch {
            errorKind = error.networkErrorKind
        }

        isLoading = false
    }
}

//
//  CarrierDetailsViewModel.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 18.02.2026.
//

import Foundation

@MainActor
final class CarrierDetailsViewModel: ObservableObject {
    @Published private(set) var option: CarrierOption
    @Published private(set) var isLoading: Bool = false

    private let dataProvider: CarrierDetailsDataProviderProtocol

    init(
        option: CarrierOption,
        dataProvider: CarrierDetailsDataProviderProtocol = CarrierDetailsDataProvider.shared
    ) {
        self.option = option
        self.dataProvider = dataProvider
    }

    func load() async {
        guard let code = option.carrierCode, !code.isEmpty else {
            return
        }

        isLoading = true

        do {
            let details = try await dataProvider.fetchCarrierDetails(code: code, system: option.carrierCodeSystem)
            guard let details else {
                isLoading = false
                return
            }

            option = CarrierOption(
                id: option.id,
                carrierName: details.name.isEmpty ? option.carrierName : details.name,
                routeTitle: option.routeTitle,
                routeNote: option.routeNote,
                dateLabel: option.dateLabel,
                departureTime: option.departureTime,
                arrivalTime: option.arrivalTime,
                durationLabel: option.durationLabel,
                hasTransfers: option.hasTransfers,
                timeSlot: option.timeSlot,
                logoURL: details.logoURL ?? option.logoURL,
                email: details.email.isEmpty ? option.email : details.email,
                phone: details.phone.isEmpty ? option.phone : details.phone,
                carrierCode: option.carrierCode,
                carrierCodeSystem: option.carrierCodeSystem
            )
        } catch {
            // Keep fallback data from search response
        }

        isLoading = false
    }
}

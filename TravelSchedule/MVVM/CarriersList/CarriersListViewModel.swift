//
//  CarriersListViewModel.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 18.02.2026.
//

import Foundation

@MainActor
final class CarriersListViewModel: ObservableObject {
    @Published private(set) var options: [CarrierOption] = []
    @Published var filters: CarrierFiltersState = CarrierFiltersState()
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorKind: NetworkErrorKind?

    let fromText: String
    let toText: String
    let fromCode: String
    let toCode: String

    private let dataProvider: CarriersListDataProviderProtocol

    var headerTitle: String {
        "\(fromText) → \(toText)"
    }

    var filteredOptions: [CarrierOption] {
        options.filter { option in
            let slotMatches = filters.selectedSlots.isEmpty || filters.selectedSlots.contains(option.timeSlot)

            let transferMatches: Bool
            switch filters.transfers {
            case .none:
                transferMatches = true
            case .some(.yes):
                transferMatches = option.hasTransfers
            case .some(.no):
                transferMatches = !option.hasTransfers
            }

            return slotMatches && transferMatches
        }
    }

    init(
        fromText: String,
        toText: String,
        fromCode: String,
        toCode: String,
        dataProvider: CarriersListDataProviderProtocol = CarriersListDataProvider.shared
    ) {
        self.fromText = fromText
        self.toText = toText
        self.fromCode = fromCode
        self.toCode = toCode
        self.dataProvider = dataProvider
    }

    func load() async {
        guard options.isEmpty else {
            return
        }

        isLoading = true
        errorKind = nil

        do {
            options = try await dataProvider.fetchCarrierOptions(
                fromCode: fromCode,
                toCode: toCode,
                fromText: fromText,
                toText: toText
            )
        } catch {
            errorKind = error.networkErrorKind
        }

        isLoading = false
    }
}

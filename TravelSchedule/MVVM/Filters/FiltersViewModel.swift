//
//  FiltersViewModel.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 19.02.2026.
//

import Foundation

@MainActor
final class FiltersViewModel: ObservableObject {
    @Published private(set) var filters: CarrierFiltersState

    init(filters: CarrierFiltersState) {
        self.filters = filters
    }

    func onToggleSlot(_ slot: TimeSlot) {
        if filters.selectedSlots.contains(slot) {
            filters.selectedSlots.remove(slot)
        } else {
            filters.selectedSlots.insert(slot)
        }
    }

    func onToggleTransfers(_ value: TransfersFilter) {
        if filters.transfers == value {
            filters.transfers = nil
        } else {
            filters.transfers = value
        }
    }

    func currentFilters() -> CarrierFiltersState {
        filters
    }
}

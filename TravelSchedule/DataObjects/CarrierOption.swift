//
//  CarrierOption.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 18.02.2026.
//

import Foundation

struct CarrierOption: Identifiable, Hashable, Sendable {
    let id: UUID
    let carrierName: String
    let routeNote: String
    let dateLabel: String
    let departureTime: String
    let arrivalTime: String
    let durationLabel: String
    let hasTransfers: Bool
    let timeSlot: TimeSlot
    let logoURL: URL?
    let email: String
    let phone: String
    let carrierCode: String?
    let carrierCodeSystem: String?

    init(
        id: UUID = UUID(),
        carrierName: String,
        routeNote: String,
        dateLabel: String,
        departureTime: String,
        arrivalTime: String,
        durationLabel: String,
        hasTransfers: Bool,
        timeSlot: TimeSlot,
        logoURL: URL?,
        email: String,
        phone: String,
        carrierCode: String? = nil,
        carrierCodeSystem: String? = nil
    ) {
        self.id = id
        self.carrierName = carrierName
        self.routeNote = routeNote
        self.dateLabel = dateLabel
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.durationLabel = durationLabel
        self.hasTransfers = hasTransfers
        self.timeSlot = timeSlot
        self.logoURL = logoURL
        self.email = email
        self.phone = phone
        self.carrierCode = carrierCode
        self.carrierCodeSystem = carrierCodeSystem
    }
}

enum TimeSlot: String, CaseIterable, Identifiable, Sendable {
    case morning = "Утро 06:00 - 12:00"
    case day = "День 12:00 - 18:00"
    case evening = "Вечер 18:00 - 00:00"
    case night = "Ночь 00:00 - 06:00"

    var id: String { rawValue }
}

enum TransfersFilter: String, Sendable {
    case yes
    case no
}

struct CarrierFiltersState: Sendable {
    var selectedSlots: Set<TimeSlot> = []
    var transfers: TransfersFilter? = nil

    var isActive: Bool {
        !selectedSlots.isEmpty || transfers != nil
    }
}

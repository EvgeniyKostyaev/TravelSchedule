//
//  CarriersListDataProvider.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 18.02.2026.
//

import Foundation

protocol CarriersListDataProviderProtocol: Sendable {
    func fetchCarrierOptions(from: String, to: String) async throws -> [CarrierOption]
}

actor CarriersListDataProvider: CarriersListDataProviderProtocol {
    static let shared = CarriersListDataProvider()

    func fetchCarrierOptions(from: String, to: String) async throws -> [CarrierOption] {
        let routeTitle = "\(from) → \(to)"

        return [
            CarrierOption(
                carrierName: "РЖД",
                routeTitle: routeTitle,
                routeNote: "С пересадкой в Костроме",
                dateLabel: "14 января",
                departureTime: "22:30",
                arrivalTime: "08:15",
                durationLabel: "20 часов",
                hasTransfers: true,
                timeSlot: .night,
                logoURL: URL(string: "https://picsum.photos/seed/rzd/100/100"),
                email: "info@rzd.ru",
                phone: "+7 (904) 329-27-71"
            ),
            CarrierOption(
                carrierName: "ФК",
                routeTitle: routeTitle,
                routeNote: "",
                dateLabel: "15 января",
                departureTime: "01:15",
                arrivalTime: "09:00",
                durationLabel: "9 часов",
                hasTransfers: false,
                timeSlot: .night,
                logoURL: URL(string: "https://picsum.photos/seed/fk/100/100"),
                email: "support@fk.ru",
                phone: "+7 (812) 555-12-34"
            ),
            CarrierOption(
                carrierName: "Урал логистика",
                routeTitle: routeTitle,
                routeNote: "",
                dateLabel: "16 января",
                departureTime: "12:30",
                arrivalTime: "21:00",
                durationLabel: "9 часов",
                hasTransfers: false,
                timeSlot: .day,
                logoURL: URL(string: "https://picsum.photos/seed/ural/100/100"),
                email: "contact@ural-log.ru",
                phone: "+7 (343) 777-45-67"
            ),
            CarrierOption(
                carrierName: "РЖД",
                routeTitle: routeTitle,
                routeNote: "С пересадкой в Костроме",
                dateLabel: "17 января",
                departureTime: "22:30",
                arrivalTime: "08:15",
                durationLabel: "20 часов",
                hasTransfers: true,
                timeSlot: .night,
                logoURL: URL(string: "https://picsum.photos/seed/rzd2/100/100"),
                email: "info@rzd.ru",
                phone: "+7 (904) 329-27-71"
            ),
            CarrierOption(
                carrierName: "ФК",
                routeTitle: routeTitle,
                routeNote: "",
                dateLabel: "17 января",
                departureTime: "01:15",
                arrivalTime: "09:00",
                durationLabel: "9 часов",
                hasTransfers: false,
                timeSlot: .night,
                logoURL: URL(string: "https://picsum.photos/seed/fk2/100/100"),
                email: "support@fk.ru",
                phone: "+7 (812) 555-12-34"
            ),
            CarrierOption(
                carrierName: "Урал логистика",
                routeTitle: routeTitle,
                routeNote: "",
                dateLabel: "18 января",
                departureTime: "12:30",
                arrivalTime: "21:00",
                durationLabel: "9 часов",
                hasTransfers: false,
                timeSlot: .day,
                logoURL: URL(string: "https://picsum.photos/seed/ural2/100/100"),
                email: "contact@ural-log.ru",
                phone: "+7 (343) 777-45-67"
            )
        ]
    }
}

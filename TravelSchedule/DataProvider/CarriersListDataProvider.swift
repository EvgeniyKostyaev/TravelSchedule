//
//  CarriersListDataProvider.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 18.02.2026.
//

import Foundation

protocol CarriersListDataProviderProtocol: Sendable {
    func fetchCarrierOptions(
        fromCode: String,
        toCode: String,
        fromText: String,
        toText: String
    ) async throws -> [CarrierOption]
}

actor CarriersListDataProvider: CarriersListDataProviderProtocol {
    static let shared = CarriersListDataProvider()

    private let searchService: SearchServiceProtocol

    init(searchService: SearchServiceProtocol = NetworkClientFactory.shared.makeSearchService()) {
        self.searchService = searchService
    }

    func fetchCarrierOptions(
        fromCode: String,
        toCode: String,
        fromText: String,
        toText: String
    ) async throws -> [CarrierOption] {
        let schedules = try await searchService.getScheduleBetweenStations(from: fromCode, to: toCode)
        let routeTitle = "\(fromText) → \(toText)"

        return (schedules.segments ?? []).map { segment in
            let carrier = segment.thread?.carrier
            let departure = Self.parseDate(segment.departure)
            let arrival = Self.parseDate(segment.arrival)

            return CarrierOption(
                carrierName: carrier?.title ?? "Перевозчик",
                routeTitle: routeTitle,
                routeNote: String(),
                dateLabel: Self.formatDate(departure),
                departureTime: Self.formatTime(departure),
                arrivalTime: Self.formatTime(arrival),
                durationLabel: Self.formatDuration(departure: departure, arrival: arrival),
                hasTransfers: false,
                timeSlot: Self.makeTimeSlot(from: departure),
                logoURL: URL(string: carrier?.logo ?? String()),
                email: carrier?.email ?? "—",
                phone: carrier?.phone ?? "—"
            )
        }
    }
}

private extension CarriersListDataProvider {
    static func parseDate(_ value: String?) -> Date? {
        guard let value else {
            return nil
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: value) {
            return date
        }

        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: value)
    }

    static func formatDate(_ date: Date?) -> String {
        guard let date else {
            return "—"
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)
    }

    static func formatTime(_ date: Date?) -> String {
        guard let date else {
            return "—"
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    static func formatDuration(departure: Date?, arrival: Date?) -> String {
        guard let departure, let arrival else {
            return "—"
        }

        let interval = max(0, arrival.timeIntervalSince(departure))
        let totalMinutes = Int(interval / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 {
            return minutes == 0 ? "\(hours) ч" : "\(hours) ч \(minutes) мин"
        }

        return "\(minutes) мин"
    }

    static func makeTimeSlot(from date: Date?) -> TimeSlot {
        guard let date else {
            return .morning
        }

        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 6..<12:
            return .morning
        case 12..<18:
            return .day
        case 18..<24:
            return .evening
        default:
            return .night
        }
    }
}

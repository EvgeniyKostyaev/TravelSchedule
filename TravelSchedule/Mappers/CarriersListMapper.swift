//
//  CarriersListMapper.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 18.02.2026.
//

import Foundation

struct CarriersListMapper: Sendable {
    private let formatter: CarrierPresentationFormatter

    init(formatter: CarrierPresentationFormatter = CarrierPresentationFormatter()) {
        self.formatter = formatter
    }

    func map(segments: [Components.Schemas.Segment], routeTitle: String) -> [CarrierOption] {
        let requestDateLabel = formatter.todayDateLabel()

        return segments.map { segment in
            let carrier = segment.thread?.carrier
            let departure = formatter.parseDateFlexible(segment.departure)
            let arrival = formatter.parseDateFlexible(segment.arrival)
            let durationSeconds = Int(segment.duration ?? 0)

            return CarrierOption(
                carrierName: carrier?.title ?? "Перевозчик",
                routeTitle: routeTitle,
                routeNote: String(),
                dateLabel: formatter.formatDate(
                    from: segment.departure,
                    fallbackDate: departure,
                    defaultLabel: requestDateLabel
                ),
                departureTime: formatter.formatTime(from: segment.departure, fallbackDate: departure),
                arrivalTime: formatter.formatTime(from: segment.arrival, fallbackDate: arrival),
                durationLabel: formatter.formatDuration(
                    seconds: durationSeconds,
                    departure: departure,
                    arrival: arrival
                ),
                hasTransfers: false,
                timeSlot: formatter.makeTimeSlot(raw: segment.departure, date: departure),
                logoURL: URL(string: carrier?.logo ?? String()),
                email: carrier?.email ?? "—",
                phone: carrier?.phone ?? "—"
            )
        }
    }
}


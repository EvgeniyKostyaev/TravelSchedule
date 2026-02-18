//
//  CarrierPresentationFormatter.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 18.02.2026.
//

import Foundation

struct CarrierPresentationFormatter: Sendable {
    func parseDateFlexible(_ value: String?) -> Date? {
        guard let value else {
            return nil
        }

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: value) {
            return date
        }

        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: value) {
            return date
        }

        let formats = [
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm",
            "yyyy-MM-dd HH:mm",
            "yyyy-MM-dd'T'HH:mm:ssXXXXX",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd HH:mm:ss Z"
        ]

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current

        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: value) {
                return date
            }
        }

        return nil
    }

    func formatDate(from raw: String?, fallbackDate: Date?, defaultLabel: String) -> String {
        if let date = fallbackDate {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "d MMMM"
            return formatter.string(from: date)
        }

        guard let raw else {
            return defaultLabel
        }

        let datePart: String
        if let match = raw.range(of: #"(\d{4})-(\d{2})-(\d{2})"#, options: .regularExpression) {
            datePart = String(raw[match])
        } else {
            return defaultLabel
        }

        let parser = DateFormatter()
        parser.locale = Locale(identifier: "en_US_POSIX")
        parser.dateFormat = "yyyy-MM-dd"
        guard let date = parser.date(from: datePart) else {
            return defaultLabel
        }

        let output = DateFormatter()
        output.locale = Locale(identifier: "ru_RU")
        output.dateFormat = "d MMMM"
        return output.string(from: date)
    }

    func todayDateLabel() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: Date())
    }

    func formatTime(from raw: String?, fallbackDate: Date?) -> String {
        if let date = fallbackDate {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }

        guard let raw else {
            return "—"
        }

        let candidate: Substring?
        if let tPart = raw.split(separator: "T", maxSplits: 1).last, raw.contains("T") {
            candidate = tPart
        } else {
            candidate = raw.split(separator: " ", maxSplits: 1).last
        }

        guard let candidate else {
            return "—"
        }

        let timePart = candidate.prefix(5)
        return timePart.count == 5 ? String(timePart) : "—"
    }

    func formatDuration(seconds: Int, departure: Date?, arrival: Date?) -> String {
        if seconds > 0 {
            return durationLabel(seconds: seconds)
        }

        guard let departure, let arrival else {
            return "—"
        }

        let interval = max(0, Int(arrival.timeIntervalSince(departure)))
        return durationLabel(seconds: interval)
    }

    func makeTimeSlot(raw: String?, date: Date?) -> TimeSlot {
        if let date {
            let hour = Calendar.current.component(.hour, from: date)
            return slot(hour: hour)
        }

        if let raw {
            let time = formatTime(from: raw, fallbackDate: nil)
            let hourString = String(time.prefix(2))
            if let hour = Int(hourString) {
                return slot(hour: hour)
            }
        }

        return .morning
    }
}

private extension CarrierPresentationFormatter {
    func durationLabel(seconds: Int) -> String {
        let totalMinutes = seconds / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 {
            return minutes == 0 ? "\(hours) ч" : "\(hours) ч \(minutes) мин"
        }

        return "\(minutes) мин"
    }

    func slot(hour: Int) -> TimeSlot {
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


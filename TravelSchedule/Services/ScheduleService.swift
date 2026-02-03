//
//  ScheduleService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 01.02.2026.
//

typealias Schedule = Components.Schemas.ScheduleResponse

protocol ScheduleServiceProtocol {
    func getStationSchedule(station: String) async throws -> Schedule
}

final class ScheduleService: BaseService, ScheduleServiceProtocol {
    
    func getStationSchedule(station: String) async throws -> Schedule {
        
        let response = try await client.getStationSchedule(query: .init(
            apikey: apikey,
            station: station
        ))
        
        return try response.ok.body.json
    }
}

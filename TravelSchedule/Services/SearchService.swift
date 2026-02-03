//
//  SearchService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 01.02.2026.
//

typealias RouteSegmentSchedules = Components.Schemas.Segments

protocol SearchServiceProtocol {
    func getScheduleBetweenStations(from: String, to: String) async throws -> RouteSegmentSchedules
}

final class SearchService: BaseService, SearchServiceProtocol {
    
    func getScheduleBetweenStations(from: String, to: String) async throws -> RouteSegmentSchedules {
        
        let response = try await client.getScheduleBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to
        ))
        
        return try response.ok.body.json
    }
}

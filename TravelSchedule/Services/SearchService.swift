//
//  SearchService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 01.02.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias RouteSegmentSchedules = Components.Schemas.Segments

protocol SearchServiceProtocol {
    func getScheduleBetweenStations(from: String, to: String) async throws -> RouteSegmentSchedules
}

final class SearchService: SearchServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleBetweenStations(from: String, to: String) async throws -> RouteSegmentSchedules {
        
        let response = try await client.getScheduleBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to
        ))
        
        return try response.ok.body.json
    }
}

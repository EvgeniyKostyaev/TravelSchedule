//
//  ThreadService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 02.02.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias ThreadStations = Components.Schemas.ThreadStationsResponse

protocol ThreadServiceProtocol {
    func getRouteStations(uid: String) async throws -> ThreadStations
}

final class ThreadService: ThreadServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getRouteStations(uid: String) async throws -> ThreadStations {
        
        let response = try await client.getRouteStations(query: .init(
            apikey: apikey,
            uid: uid
        ))
        
        return try response.ok.body.json
    }
}

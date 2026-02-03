//
//  ThreadService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 02.02.2026.
//

typealias ThreadStations = Components.Schemas.ThreadStationsResponse

protocol ThreadServiceProtocol {
    func getRouteStations(uid: String) async throws -> ThreadStations
}

final class ThreadService: BaseService, ThreadServiceProtocol {
    
    func getRouteStations(uid: String) async throws -> ThreadStations {
        
        let response = try await client.getRouteStations(query: .init(uid: uid
))
        
        return try response.ok.body.json
    }
}

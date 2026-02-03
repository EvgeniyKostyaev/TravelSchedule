//
//  NearestStationsService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 30.01.2026.
//

typealias NearestStations = Components.Schemas.Stations

protocol NearestStationsServiceProtocol {
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations
}

final class NearestStationsService: BaseService, NearestStationsServiceProtocol {
    
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        
        let response = try await client.getNearestStations(query: .init(
            lat: lat,
            lng: lng,
            distance: distance
        ))
        
        return try response.ok.body.json
    }
}

//
//  NearestSettlementService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 02.02.2026.
//

typealias NearestCity = Components.Schemas.NearestCityResponse

protocol NearestSettlementServiceProtocol {
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCity
}

final class NearestSettlementService: BaseService, NearestSettlementServiceProtocol {
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCity {
        
        let response = try await client.getNearestCity(query: .init(
            lat: lat,
            lng: lng
        ))
        
        return try response.ok.body.json
    }
}

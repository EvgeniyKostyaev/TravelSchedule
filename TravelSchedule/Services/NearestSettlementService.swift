//
//  NearestSettlementService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 02.02.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCity = Components.Schemas.NearestCityResponse

protocol NearestSettlementServiceProtocol {
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCity
}

final class NearestSettlementService: NearestSettlementServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCity {
        
        let response = try await client.getNearestCity(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng
        ))
        
        return try response.ok.body.json
    }
}

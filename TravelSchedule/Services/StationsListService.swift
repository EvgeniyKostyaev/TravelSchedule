//
//  StationsListService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 02.02.2026.
//

import Foundation

typealias AllStations = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations() async throws -> AllStations
}

final class StationsListService: BaseService, StationsListServiceProtocol {
    
    func getAllStations() async throws -> AllStations {
        let response = try await client.getAllStations(query: .init())
        
        var fullData = Data()

        for try await chunk in try response.ok.body.html {
            fullData.append(contentsOf: chunk)
        }

        let allStations = try JSONDecoder().decode(AllStations.self, from: fullData)
        return allStations
    }
}

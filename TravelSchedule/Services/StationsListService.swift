//
//  StationsListService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 02.02.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias AllStations = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations() async throws -> AllStations
}

final class StationsListService: StationsListServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getAllStations() async throws -> AllStations {
        let response = try await client.getAllStations(query: .init(apikey: apikey))
        
        var fullData = Data()

        for try await chunk in try response.ok.body.html {
            fullData.append(contentsOf: chunk)
        }

        let allStations = try JSONDecoder().decode(AllStations.self, from: fullData)
        return allStations
    }
}

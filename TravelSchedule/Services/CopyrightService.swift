//
//  CopyrightService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 02.02.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleBannersData = Components.Schemas.ScheduleBannersData

protocol CopyrightServiceProtocol {
    func getScheduleBannersData() async throws -> ScheduleBannersData
}

final class CopyrightService: CopyrightServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleBannersData() async throws -> ScheduleBannersData {
        
        let response = try await client.getScheduleBannersData(query: .init(
            apikey: apikey
        ))
        
        return try response.ok.body.json
    }
}

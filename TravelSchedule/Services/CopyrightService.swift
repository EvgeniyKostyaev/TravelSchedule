//
//  CopyrightService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 02.02.2026.
//

typealias ScheduleBannersData = Components.Schemas.ScheduleBannersData

protocol CopyrightServiceProtocol {
    func getScheduleBannersData() async throws -> ScheduleBannersData
}

final class CopyrightService: BaseService, CopyrightServiceProtocol {
    
    func getScheduleBannersData() async throws -> ScheduleBannersData {
        
        let response = try await client.getScheduleBannersData(query: .init())
        
        return try response.ok.body.json
    }
}

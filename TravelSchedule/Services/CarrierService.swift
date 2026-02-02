//
//  CarrierService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 02.02.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias Carrier = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func getCarrierInfo(code: String, system: String, lang: String, format: String) async throws -> Carrier
}

final class CarrierService: CarrierServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCarrierInfo(code: String, system: String, lang: String, format: String) async throws -> Carrier {
        let response = try await client.getCarrierInfo(query: .init(
            apikey: apikey,
            code: code,
            system: system,
            lang: lang,
            format: format
        ))
        
        return try response.ok.body.json
    }
}

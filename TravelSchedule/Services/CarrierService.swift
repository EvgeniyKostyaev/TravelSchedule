//
//  CarrierService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 02.02.2026.
//

typealias Carrier = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func getCarrierInfo(code: String, system: String?, lang: String?, format: String?) async throws -> Carrier
}

final class CarrierService: BaseService, CarrierServiceProtocol {
    
    func getCarrierInfo(code: String, system: String? = nil, lang: String? = nil, format: String? = nil) async throws -> Carrier {
        let response = try await client.getCarrierInfo(query: .init(
            code: code,
            system: system,
            lang: lang,
            format: format
        ))
        
        return try response.ok.body.json
    }
}

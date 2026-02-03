//
//  NetworkClientFactory.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 03.02.2026.
//

import Foundation
import OpenAPIURLSession

final class NetworkClientFactory {
    static let shared = NetworkClientFactory()
    
    let client: Client
    
    private init() {
        let middleware = APIKeyMiddleware(apiKey: "11ee95a9-5d01-48d4-a612-52ffa3472cc6")
        
        self.client = Client(
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport(),
            middlewares: [middleware]
        )
    }
    
    func makeCarrierService() -> CarrierServiceProtocol {
        CarrierService(client: client)
    }
    
    func makeCopyrightService() -> CopyrightServiceProtocol {
        CopyrightService(client: client)
    }
    
    func makeNearestSettlementService() -> NearestSettlementServiceProtocol {
        NearestSettlementService(client: client)
    }
    
    func makeNearestStationsService() -> NearestStationsServiceProtocol {
        NearestStationsService(client: client)
    }
    
    func makeScheduleService() -> ScheduleServiceProtocol {
        ScheduleService(client: client)
    }
    
    func makeSearchService() -> SearchServiceProtocol {
        SearchService(client: client)
    }
    
    func makeStationsListService() -> StationsListServiceProtocol {
        StationsListService(client: client)
    }
    
    func makeThreadService() -> ThreadServiceProtocol {
        ThreadService(client: client)
    }
}

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
    let apikey: String
    
    private init() {
        self.client = Client(
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport()
        )
        self.apikey = "11ee95a9-5d01-48d4-a612-52ffa3472cc6"
    }
    
    func makeCarrierService() -> CarrierServiceProtocol {
        CarrierService(client: client, apikey: apikey)
    }
    
    func makeCopyrightService() -> CopyrightServiceProtocol {
        CopyrightService(client: client, apikey: apikey)
    }
    
    func makeNearestSettlementService() -> NearestSettlementServiceProtocol {
        NearestSettlementService(client: client, apikey: apikey)
    }
    
    func makeNearestStationsService() -> NearestStationsServiceProtocol {
        NearestStationsService(client: client, apikey: apikey)
    }
    
    func makeScheduleService() -> ScheduleServiceProtocol {
        ScheduleService(client: client, apikey: apikey)
    }
    
    func makeSearchService() -> SearchServiceProtocol {
        SearchService(client: client, apikey: apikey)
    }
    
    func makeStationsListService() -> StationsListServiceProtocol {
        StationsListService(client: client, apikey: apikey)
    }
    
    func makeThreadService() -> ThreadServiceProtocol {
        ThreadService(client: client, apikey: apikey)
    }
}

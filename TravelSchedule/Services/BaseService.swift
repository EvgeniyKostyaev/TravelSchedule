//
//  BaseService.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 03.02.2026.
//

class BaseService {
    let client: Client
    let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
}

//
//  APIKeyMiddleware.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 03.02.2026.
//

import Foundation

import OpenAPIRuntime
import OpenAPIURLSession
import HTTPTypes

struct APIKeyMiddleware: ClientMiddleware {
    
    let apiKey: String

    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {

        var request = request
        request.headerFields[.authorization] = apiKey

        return try await next(request, body, baseURL)
    }
}

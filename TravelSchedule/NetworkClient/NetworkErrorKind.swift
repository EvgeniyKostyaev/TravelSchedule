//
//  NetworkErrorKind.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 17.02.2026.
//

import Foundation

enum NetworkErrorKind: Equatable {
    case noInternet
    case other
}

extension Error {
    var networkErrorKind: NetworkErrorKind {
        let nsError = self as NSError
        if Self.isNoInternet(nsError) {
            return .noInternet
        }
        
        if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError,
           Self.isNoInternet(underlyingError) {
            return .noInternet
        }
        
        return .other
    }
    
    private static func isNoInternet(_ error: NSError) -> Bool {
        guard error.domain == NSURLErrorDomain else {
            return false
        }
        
        switch error.code {
        case URLError.notConnectedToInternet.rawValue,
            URLError.networkConnectionLost.rawValue,
            URLError.dataNotAllowed.rawValue,
            URLError.internationalRoamingOff.rawValue:
            return true
        default:
            return false
        }
    }
}

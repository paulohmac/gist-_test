//
//  APIErrors.swift
//  Mapping network errors 
//
//  Created by Paulo H.M. on 16/01/22.
//

import UIKit

/// Mapping comum server side errors
public enum RequestErrors : Error{
        case requestFailed(description: String)
        case jsonConversionFailure(description: String)
        case invalidData
        case responseUnsuccessful(description: String)
        case jsonParsingFailure
        case noInternet
        case failedSerialization
        case notFound(code : Int)

        public var customDescription: String {
            switch self {
            case let .requestFailed(description): return "Request Failed error -> \(description)"
            case .invalidData: return "Invalid Data error)"
            case let .responseUnsuccessful(description): return "Response Unsuccessful error -> \(description)"
            case .jsonParsingFailure: return "JSON Parsing Failure error)"
            case let .jsonConversionFailure(description): return "JSON Conversion Failure -> \(description)"
            case .noInternet: return "No internet connection"
            case .failedSerialization: return "serialization print for debug failed."
            case .notFound(_): return "http \(rawCode)"
            }
        }
    
        public var rawCode : Int {
            switch self {
                case .notFound(let code): return code
            default:
                return -1
            }
        }
}

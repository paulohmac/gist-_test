//
//  RequestResult.swift
//  
//
//  Created by Paulo H.M. on 16/01/22.
//

import UIKit
 
public enum RequestResult {
    //Return codable for result
    case successApi(Any)
    //Error mapping return
    case failureApi(RequestErrors)

    public func associatedValue() -> Any {
        switch self {
        case .successApi(let value):
            return value
        case .failureApi(let value):
            return value
        }
    }
}

//
//  Configuration.swift
//  Comum configuration of network framework
//
//  Created by Paulo H.M. on 16/01/22.
//

import UIKit
import Alamofire
    public struct Configuration {
        //Github server
        static let base_url = "https://api.github.com/gists"
    }
//Mapring all url
public enum URLMapping {
    case main
    case detail(idGist: String)
    
    var config: (url: String, method: APIMethod, encoding : ParameterEncoding) {
            switch self {
            case .main:
                return ("/public", .get, URLEncoding() )
            case .detail(let idGist):
                return ("/\(idGist)", .get, URLEncoding())
        }
    }
}
///Http Codes mapping
enum ApiHTTPCodes : Int {
    case invalidToken        = 401   //Status code 403
    case accessDenied        = 402   //Status code 403
    case forbidden           = 403   //Status code 403
    case notFound            = 404   //Status code 404
    case conflict            = 409   //Status code 409
    case internalServerError = 500   //Status code 500
}
/// Http methods mapping
enum APIMethod : String, CaseIterable{
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

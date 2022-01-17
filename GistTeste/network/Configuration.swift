//
//  Configuration.swift
//  GistTeste
//
//  Created by Paulo H.M. on 16/01/22.
//

import UIKit
import Alamofire
    public struct Configuration {
        static let base_url = "https://apiary.io/mockserver/%@"

    }


public enum URLMapping: CaseIterable {
    case main
    case logout
    var config: (url: String, method: APIMethod, encoding : ParameterEncoding) {
            switch self {
            case .main:
                return ("/user/login", .get, URLEncoding() )
            case .logout:
                return ("/user/logout", .get, URLEncoding())
        }
    }
}


public class NetworkFactory{
    public static func getInstante()->APIRequest{
        return AlamoFireAPIRequest()
    }
}
///Http Codes mapping
enum ApiHTTPCodes : Int {
    case invalidToken           = 401   //Status code 403
    case accessDenied           = 402   //Status code 403
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

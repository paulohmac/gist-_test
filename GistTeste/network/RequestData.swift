//
//  RequestData.swift
//  GistTeste
//
//  Created by Paulo H.M. on 21/01/22.
//

import UIKit


public protocol RequestType{
    var headers :  [String: String]? {get set}
    //Http parameters
    var parameters : [String : Any]? {get set}
    //Enum with url request
    var url : URLMapping {get set}
    //T type for request result
}

public struct RequestData<T> : RequestType{
    //Http Headers
    public var headers :  [String: String]?
    //Http parameters
    public var parameters : [String : Any]?
    //Enum with url request
    public var url : URLMapping
    //T type for request result
    public var retType : T.Type
    //Dont remove this default header parameters!
    public init(headers :  [String: String] = getDefaultHeaders(),
         parameters : [String : Any]?,
         url : URLMapping,
         retType :  T.Type){
        self.headers = headers
        self.parameters = parameters
        self.url = url
        self.retType = retType
    }
    /// generate default headers
    /// - Returns: map with headers
    public static func getDefaultHeaders()->[String:String] {
          let headers: [String:String] = [
             "Content-type": "application/json"
          ]
          return headers
      }
}

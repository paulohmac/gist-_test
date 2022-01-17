//
//  AlamofireProvider.swift
//  GistTeste
//
//  Created by Paulo H.M. on 16/01/22.
//

import Foundation
import Alamofire
import Moya

/// protocoll for netwoork framework
public protocol APIRequest {
    func sendRequest(_ requestData : RequestData<BaseCodable>, _ completion: @escaping (RequestResult) -> Void)
}

/// Alamofire Target implementation
public class AlamoFireAPIRequest :  APIRequest, TargetType{
    var requestData: RequestData<BaseCodable>? = nil

    init(){}
    /// Send request to server using moya configuration
    /// - Parameters:
    ///   - requestData: structure contains request data
    ///   - completion: request result
    public func sendRequest(_ requestData: RequestData<BaseCodable>, _ completion: @escaping (RequestResult) -> Void) {
        self.requestData = requestData
        //Show complete parameters if in debug mod
        
        let provider : MoyaProvider<AlamoFireAPIRequest> = MoyaProvider<AlamoFireAPIRequest>()
        
        NetWorkUtil.checkInternetConnection({ ret  in
            if (ret){
                provider.request(self, completion: { result  in
                    switch result {
                            case let .success(response):
                                switch response.statusCode{
                                    case ApiHTTPCodes.forbidden.rawValue,
                                         ApiHTTPCodes.notFound.rawValue,
                                         ApiHTTPCodes.internalServerError.rawValue,
                                         ApiHTTPCodes.accessDenied.rawValue,
                                         ApiHTTPCodes.invalidToken.rawValue:
                                        completion(.failureApi(.notFound(code:response.statusCode )))
                                        return
                                    default:
                                        break;
                                }
                                do {
                                    let results = try JSONDecoder().decode(requestData.retType.self  , from: response.data)
                                    completion(.successApi(results))
                                } catch let error {
                                    completion(.failureApi(.jsonConversionFailure(description: error.localizedDescription)))
                                }
                            case let .failure(error):
                                completion(.failureApi(.requestFailed(description:error.localizedDescription)))
                    }
                })
            }else{
                completion(.failureApi(.noInternet))
            }
        })
    }
    /// Task
    public var task: Task {
        return .requestParameters(parameters: requestData?.parameters ?? [:] , encoding: requestData!.url.config.encoding)
    }
    
    /// Vee pay server URL config
    public var baseURL: URL {
     return URL(string: Configuration.base_url)!
    }
    ///Path for request
    public var path: String {
        return requestData?.url.config.url ?? ""
    }
    ///HTTP Method
    public var method: Moya.Method {
        return Moya.Method(rawValue: self.requestData?.url.config.method.rawValue ?? "")
    }
    //For future mocke data
    public var sampleData: Data {
        return Data()
    }
    
    public var parameterEncoding: Moya.ParameterEncoding {
        return requestData?.url.config.encoding ?? JSONEncoding()
    }
    
    public var headers: [String : String]? {
        return requestData?.headers
    }
}


public struct RequestData<T: Decodable>{
    //Http Headers
    var headers :  [String: String]?
    //Http parameters
    var parameters : [String : Any]?
    //Enum with url request
    var url : URLMapping
    //T type for request result
    var retType : T.Type
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

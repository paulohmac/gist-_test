//
//  AlamofireProvider.swift
//  Framework create for ServerSide request usind Alamofire and Moya
//
//  Created by Paulo H.M. on 16/01/22.
//

import Foundation
import Alamofire
import Moya

/// protocoll for network framework
public protocol APIRequest {
    func sendRequest(_ requestData : RequestData<BaseCodable>, _ completion: @escaping (RequestResult) -> Void)

    func sendRequestWithArray(_ requestData : RequestData<[BaseCodable]>, _ completion: @escaping (RequestResult) -> Void)
}

/// Alamofire Target implementation
public class AlamoFireAPIRequest :  APIRequest, TargetType{
    var requestData: RequestType? = nil

    init(){}
    
    public func sendRequestWithArray(_ requestData : RequestData<[BaseCodable]>, _ completion: @escaping (RequestResult) -> Void){
        self.requestData = requestData
        sendRequestToServer( { ret in
            completion(ret)
        })
    }
    /// Send request to server using moya configuration
    /// - Parameters:
    ///   - requestData: structure contains request data
    ///   - completion: request result
    public func sendRequest(_ requestData: RequestData<BaseCodable>, _ completion: @escaping (RequestResult) -> Void) {
        self.requestData = requestData
        
        sendRequestToServer( { ret in
            completion(ret)
        })
        //Show complete parameters if in debug mod
    }

    private func sendRequestToServer( _ completion: @escaping (RequestResult) -> Void){
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
                                do {// TODO: feito para contornar as limitações do Generics, fixe nas próximas versões do framework\
                                    if let baseType = self.requestData as? RequestData<BaseCodable> {
                                        let results = try JSONDecoder().decode ( Gist.self , from: response.data)
                                        completion(.successApi(results))
                                    }else if let baseType = self.requestData as?  RequestData<[BaseCodable]>{
                                        let results = try JSONDecoder().decode ( [Gist] .self , from: response.data)
                                        completion(.successApi(results))
                                    }
                        
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




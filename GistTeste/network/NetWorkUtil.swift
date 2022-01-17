//
//  NetWorkUtil.swift
//  GistTeste
//
//  Created by Paulo H.M. on 16/01/22.
//

import UIKit
import Alamofire

class NetWorkUtil {
    /// check network connection
    /// - Parameter completion: true with connection active
    public static func checkInternetConnection( _ completion: @escaping (Bool) -> Void){
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening(onUpdatePerforming: { _ in
               if let isNetworkReachable = reachabilityManager?.isReachable,
                   isNetworkReachable == true {
                    completion(true)
               } else {
                    completion(false)
               }
        })
    }
}

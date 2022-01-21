//
//  NetworkFactory.swift
//  Factory for network service
//
//  Created by Paulo H.M. on 21/01/22.
//

import UIKit

public class NetworkFactory{
    public static func getInstante()->APIRequest{
        return AlamoFireAPIRequest()
    }
}

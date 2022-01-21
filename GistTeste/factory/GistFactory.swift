//
//  Factory.swift
//  Incomplete Factory for propect
//
//  Created by Paulo H.M. on 21/01/22.
//

import UIKit

enum GistFactory {
    case dataSource, mainViewModel, network
    
    func getInstance()->Any{
        switch self{
        case .dataSource:
            return DataSourceRealm()
        case .mainViewModel:
            return MainViewModel()
        case .network:
            return AlamoFireAPIRequest()
        }
    }

}

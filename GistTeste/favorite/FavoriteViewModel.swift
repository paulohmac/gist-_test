//
//  FavoriteViewModel.swift
//  GistTeste
//
//  Created by Paulo H.M. on 19/01/22.
//

import UIKit

class FavoriteViewModel: ObservableObject {

    @Published var favoriteList  = [Favorite]()
    
    public func getFavorites(_ completion : @escaping (() -> Void)){
        if let dataSource =  GistFactory.dataSource.getInstance() as? DataSource {
            favoriteList = dataSource.listFavorites()
            completion()
        }
    }
}

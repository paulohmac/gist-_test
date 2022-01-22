//
//  DataSource.swift
//  Datasource for favorite persitence, CRUD operations
//
//  Created by Paulo H.M. on 21/01/22.
//

import UIKit
import RealmSwift


protocol DataSource{
    func listFavorites()->[Favorite]
    func saveFavorite(item : Gist)
    func deleteFavorite(item : Gist)
    func itemExists(id : String)->Bool
}

class DataSourceRealm : DataSource{
    
    private func getRealm()->Realm{
        let localRealm = try! Realm()
        return localRealm
    }
    // MARK: - Crud opreations
    func listFavorites()->[Favorite]{
        let localRealm = getRealm()
        let favoriteList = localRealm.objects(Favorite.self)
        return favoriteList.reversed()
    }
   
    func saveFavorite(item : Gist){
        var file : FileDetail?

        if let key = item.files.keys.first, let item = item.files[key] {
            file = item
        }

        let favorite = Favorite()
        favorite.idGist = item.id ?? ""
        favorite.ownerUrlPhoto = item.owner?.avatarUrl ?? ""
        favorite.content = file?.content ?? ""
        favorite.login = item.owner?.login ?? ""
        favorite.fileType = file?.type ?? ""
        favorite.filename = file?.content ?? ""

        let localRealm = getRealm()
        try! localRealm.write {
            localRealm.add(favorite)
        }
    }
    
    func deleteFavorite(item : Gist){
        let list = getRealm().objects(Favorite.self)
        let item = list.first(where: {
            $0.idGist ==  item.id
        })
        
        guard let item = item else{
            return
        }

        let localRealm = getRealm()
        try! localRealm.write {
            localRealm.delete(item)
        }
    }

    func itemExists(id : String)->Bool{
        let list = getRealm().objects(Favorite.self)
        let item = list.first(where: {
            $0.idGist ==  id
        })
        if item != nil {
            return true
        }else{
            return false
        }
        
    }

}

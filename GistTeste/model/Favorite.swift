//
//  Favorite.swift
//  Model only for favorite persistence in Realm
//  Created by Paulo H.M. on 21/01/22.
//

import UIKit
import RealmSwift
import Realm

@objcMembers
class Favorite: Object, Identifiable {
    dynamic var idGist : String  = ""
    dynamic var ownerUrlPhoto : String  = ""
    dynamic var fileType : String = ""
    dynamic var content : String = ""
    dynamic var login : String = ""
    dynamic var type : String = ""
    dynamic var filename : String = ""

    convenience init(idGist: String, ownerUrlPhoto : String, content : String, login : String, type : String, filename : String ) {
        self.init()
        self.idGist = idGist
        self.ownerUrlPhoto = ownerUrlPhoto
        self.fileType = fileType
        self.content = content
        self.login = login
        self.type = type
        self.filename = filename
    }

}

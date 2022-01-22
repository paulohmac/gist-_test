//
//  Gist.swift
//  Model for github request
//  Use Class instead Structs because Swift Generics limitations
//  mapping data from: https://api.github.com/gists/5df645aa1197d1d9e29dabe52af4f982
//  and https://api.github.com/gists/
//  Created by Paulo H.M. on 17/01/22.
//

import UIKit

typealias GistList = [Gist]


class Gist: BaseCodable, Identifiable {
    var description : String? = ""
    var comments : String? = ""
    var htmlUrl : String? = ""
    var createdAt : String? = ""
    var owner : Owner? = nil
    var id : String? = ""
    var files : [String : FileDetail] = [String : FileDetail]()
    var favorite : Bool = false

    enum Gist: CodingKey {
            case id, description, comments, htmlUrl, createdAt, owner, files
     }
    override init() {
        super.init()
    }
    /// required constructor for all codable mapping fields
    /// - Parameter decoder: decoder
    /// - Throws: decoding error
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try? decoder.container(keyedBy: Gist.self)
        self.id = try? container?.decode(String.self, forKey: .id)
        self.description = try? container?.decode(String.self, forKey: .description)
        self.comments = try? container?.decodeIfPresent(String.self, forKey: .comments)
        self.htmlUrl = try? container?.decodeIfPresent(String.self, forKey: .htmlUrl)
        self.createdAt = try? container?.decodeIfPresent(String.self, forKey: .createdAt)
        self.owner = try? container?.decodeIfPresent(Owner.self, forKey: .owner)
        self.files = try! container?.decodeIfPresent([String : FileDetail].self, forKey: .files) ?? [String : FileDetail]()
    }
}

class Owner : BaseCodable, Identifiable {
    var login : String?
    var id : String?
    var avatarUrl : String?
    var htmlUrl : String?

    enum Owner: CodingKey {
            case login, id, avatar_url, htmlUrl
     }
    /// required constructor for all codable mapping fields
    /// - Parameter decoder: decoder
    /// - Throws: decoding error
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try? decoder.container(keyedBy: Owner.self)
        self.login = try? container?.decode(String.self, forKey: .login)
        self.id = try? container?.decode(String.self, forKey: .id)
        self.avatarUrl = try? container?.decodeIfPresent(String.self, forKey: .avatar_url)
        self.htmlUrl = try? container?.decodeIfPresent(String.self, forKey: .htmlUrl)
    }
}

class Files : BaseCodable, Identifiable {
    var filename : [ String : FileDetail]?
    enum Files: CodingKey {
        case filename
     }
    /// required constructor for all codable mapping fields
    /// - Parameter decoder: decoder
    /// - Throws: decoding error
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try? decoder.container(keyedBy: Files.self)
        self.filename = try? container?.decode([ String : FileDetail].self, forKey: .filename)
    }
}
 
class FileDetail : BaseCodable, Identifiable {
    var type : String?
    var language : String?
    var rawUrl : String?
    var size : String?
    var truncated : String?
    var content : String?
    var filename : String?

    enum FileDetail: CodingKey {
        case  type, language, raw_url, size,truncated, content, filename
     }
    /// required constructor for all codable mapping fields
    /// - Parameter decoder: decoder
    /// - Throws: decoding error
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try? decoder.container(keyedBy: FileDetail.self)
        self.type = try? container?.decode(String.self, forKey: .type)
        self.language = try? container?.decodeIfPresent(String.self, forKey: .language)
        self.rawUrl = try? container?.decodeIfPresent(String.self, forKey: .raw_url)
        self.size = try? container?.decodeIfPresent(String.self, forKey: .size)
        self.truncated = try? container?.decodeIfPresent(String.self, forKey: .truncated)
        self.content = try? container?.decodeIfPresent(String.self, forKey: .content)
        self.filename = try? container?.decodeIfPresent(String.self, forKey: .filename)
        
    }
}

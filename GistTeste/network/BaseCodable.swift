//
//  BaseCodable.swift
//  Mandatory Codable for working com network framework, generic limitation dont work with protocols
//
//  Created by Paulo H.M. on 16/01/22.
//

import UIKit

public class BaseCodable : Codable{
    public let statusCode : Int?
    public let message : String?
    public let code : Int?

    enum BaseCodable: CodingKey {
            case statusCode, message, code
     }
    init() {
        statusCode = 0
        message = ""
        code = 0
    }
    /// required constructor for all codable mapping fields
    /// - Parameter decoder: decoder
    /// - Throws: decoding error
    required public init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: BaseCodable.self)
        self.statusCode = try? container?.decode(Int.self, forKey: .statusCode)
        self.message = try? container?.decodeIfPresent(String.self, forKey: .message)
        self.code = try? container?.decodeIfPresent(Int.self, forKey: .code)
    }
}


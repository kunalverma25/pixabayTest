//
//  NKDecoder.swift
//  PixabayNetworkingKit
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import Foundation

public enum APIDecodingType {
    case json
    case xml
}

class ResponseDecoder {
    
    var decodingType: APIDecodingType
    
    init(_ type: APIDecodingType = .json) {
        decodingType = type
    }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        switch decodingType {
        case .json:
            return try JSONDecoder().decode(T.self, from: data)
        case .xml:
            // Implement XML Decoding here
            // Eg - https://github.com/MaxDesiatov/XMLCoder
            throw NKError(message: "XML Decoding not implemted as of yet")
        }
    }
}

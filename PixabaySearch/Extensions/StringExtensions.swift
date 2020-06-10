//
//  StringExtensions.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import Foundation

extension String {
    var urlEncoded: String? {
        let unreserved = "*-._"
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: unreserved)
        allowed.insert(charactersIn: " ")
        var encoded = addingPercentEncoding(withAllowedCharacters: allowed)
        encoded = encoded?.replacingOccurrences(of: " ", with: "+")
        return encoded
    }
}

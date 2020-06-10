//
//  NKError.swift
//  PixabayNetworkingKit
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import Foundation

public struct NKError: Error {
    public var message: String
    public init(message: String?) {
        self.message = (message != nil && message?.isEmpty != true) ? ( message ?? "") : "Something went wrong"
    }
}

extension NKError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(self.message, comment: "NK Error")
    }
}

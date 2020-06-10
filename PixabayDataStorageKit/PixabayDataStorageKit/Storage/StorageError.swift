//
//  StorageError.swift
//  PixabayDataStorageKit
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import Foundation

public enum StorageError: Error {
    case intializationFailure(message: String)
    case fetchError(message: String)
    case saveError(message: String)
}

enum ErrorMessages: String {
    case intializationFailure
    case fetchError
    case saveError
}

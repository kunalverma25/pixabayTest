//
//  AppConstants.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import Foundation

struct AppConstants {
    
    /// Shared Singleton Instance
    static let main = AppConstants()
    
    // Private for restricting access to structure
    private init() { }
    
    /// Storage for application wide constants
    let pixabayAPIKey = "16971455-2a40fd7a1924a6c8ae46f3bfe"
    
}

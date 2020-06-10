//
//  DataStorageKit.swift
//  PixabayDataStorageKit
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import Foundation

public enum StorageType {
    // For demo using Userdefaults, which the most basic and crude way of storing data
    case userDefaults
    // Add Cases like CoreData, Realm, Directory etc..
}

// Public protocol for future use cases
// To add a common layer on top of custom data types
//public protocol PixabayStorageData: NSCoding/Codable {
//    var saveData: Data?
//    Extra Variables/Rules Here
//}

final public class DataStorageKit {
    
    // MARK: - Private functionality and variables
    private static var storageKit: DataStorageKit?
    private static var storageType: StorageType = .userDefaults
    private static var storagelimit: Int = 0
    
    // Keys for different data types
    private static let SEARCH_TERM_STORAGE_KEY = "SEARCH_TERM_STORAGE_KEY"
    
    // MARK: - Initialization
    // This initization can be made general for all use cases
    // Currently this handles only one simple use case
    // Only for demo purpose, this handling should not be used in actual prod apps
    static public func initializeSearchStorage(_ type: StorageType = .userDefaults, limit: Int = 10) {
        storageKit = DataStorageKit()
        storageType = type
        storagelimit = limit
        // Add Cases like Limit of type, Data Types to store etc etc
        // Public Protocol with a defined structure would be better for the data that needs to be saved
    }
    
    private init() { }
    
    public static func saveSearchTerm(_ term: String) throws {
        guard let storageKit = storageKit else {
            throw StorageError.intializationFailure(message: ErrorMessages.intializationFailure.rawValue)
        }
        storageKit.saveSearchTerm(term)
    }
    
    public static func getSearchTerms() throws -> [String] {
        guard let storageKit = storageKit else {
            throw StorageError.intializationFailure(message: ErrorMessages.intializationFailure.rawValue)
        }
        return storageKit.getSearchTerms()
    }
    
    public static func clearSearchHistory() throws {
        guard let storageKit = storageKit else {
            throw StorageError.intializationFailure(message: ErrorMessages.intializationFailure.rawValue)
        }
        return storageKit.clearSearchHistory()
    }
    
}

extension DataStorageKit {
    
    // Default handling for User Defaults for now
    // Switch internally depending on initialization type
    
    func saveSearchTerm(_ term: String) {
        let defaults = UserDefaults.standard
        var searchArr: [String] = (defaults.array(forKey: DataStorageKit.SEARCH_TERM_STORAGE_KEY) as? [String]) ?? []
        if searchArr.contains(term) {
            searchArr.removeAll(where: { $0 == term })
        }
        searchArr.insert(term, at: 0)
        // 10 is the limit here
        searchArr = Array(searchArr.prefix(DataStorageKit.storagelimit))
        saveSearchArray(searchArr)
    }
    
    func getSearchTerms() -> [String] {
        let defaults = UserDefaults.standard
        guard let searchArr = defaults.stringArray(forKey: DataStorageKit.SEARCH_TERM_STORAGE_KEY) else {
            return []
        }
        // perform any other operations here
        return searchArr
    }
    
    func clearSearchHistory() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: DataStorageKit.SEARCH_TERM_STORAGE_KEY)
    }
    
    private func saveSearchArray(_ arr: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(arr, forKey: DataStorageKit.SEARCH_TERM_STORAGE_KEY)
    }
}

extension DataStorageKit {
    
    // Handle different Data Storage Cases and throw errors accordingly
    // One layer for each type of Data Storage (CD, Realm, UserDefaults etc etc)
    // UserDefaults handling above
    
}

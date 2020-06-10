//
//  ImageSearchStorageWorker.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit
import PixabayDataStorageKit

class ImageSearchStorageWorker {
    func getSavedQueriesFromDB() -> [String] {
        return (try? DataStorageKit.getSearchTerms()) ?? []
    }
    
    func saveQueryInDB(_ term: String) {
        try? DataStorageKit.saveSearchTerm(term)
    }
}

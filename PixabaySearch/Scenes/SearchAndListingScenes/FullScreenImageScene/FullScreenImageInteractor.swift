//
//  FullScreenImageInteractor.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

protocol FullScreenImageBusinessLogic: AnyObject {
    func downloadImage(url: String)
}

protocol FullScreenImageDataStore {
    var images: [PixImages]? { get set }
    var index: Int? { get set }
}

class FullScreenImageInteractor: FullScreenImageBusinessLogic, FullScreenImageDataStore {
    var presenter: FullScreenImagePresentationLogic?
    
    // MARK: DataStore
    var images: [PixImages]?
    var index: Int?
    
    // MARK: Business Logic
    func downloadImage(url: String) {
        
    }
}

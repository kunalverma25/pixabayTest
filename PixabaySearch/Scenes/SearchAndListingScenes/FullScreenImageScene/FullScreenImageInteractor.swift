//
//  FullScreenImageInteractor.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

protocol FullScreenImageBusinessLogic: AnyObject {
    func doSomething()
}

protocol FullScreenImageDataStore {
    //var name: String { get set }
}

class FullScreenImageInteractor: FullScreenImageBusinessLogic, FullScreenImageDataStore {
    var presenter: FullScreenImagePresentationLogic?
    var worker: FullScreenImageWorker?
    
    // MARK: Business Logic
    
    func doSomething() {
        worker = FullScreenImageWorker()
        worker?.doSomeWork()
        
        presenter?.presentSomething()
    }
}

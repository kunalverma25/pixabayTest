//
//  ImageSearchInteractor.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

protocol ImageSearchBusinessLogic: AnyObject {
    func doSomething()
}

protocol ImageSearchDataStore {
    //var name: String { get set }
}

class ImageSearchInteractor: ImageSearchBusinessLogic, ImageSearchDataStore {
    var presenter: ImageSearchPresentationLogic?
    var worker: ImageSearchWorker?
    
    // MARK: Business Logic
    
    func doSomething() {
        worker = ImageSearchWorker()
        worker?.doSomeWork()
    }
}

//
//  ResultsListInteractor.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

protocol ResultsListBusinessLogic: AnyObject {
    func doSomething()
}

protocol ResultsListDataStore {
    var searchResult: ImageSearch.PixSearchResult? { get set }
}

class ResultsListInteractor: ResultsListBusinessLogic, ResultsListDataStore {
    var presenter: ResultsListPresentationLogic?
    var worker: ResultsListWorker?
    
    // MARK: DataStore
    var searchResult: ImageSearch.PixSearchResult?
    
    // MARK: Business Logic
    
    func doSomething() {
        worker = ResultsListWorker()
        worker?.doSomeWork()
        
        presenter?.presentSomething()
    }
}

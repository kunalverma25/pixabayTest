//
//  ImageSearchInteractor.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

protocol ImageSearchBusinessLogic: AnyObject {
    func fetchSavedQueries()
    func searchImages(query: String)
}

protocol ImageSearchDataStore {
    var savedQueries: [String] { get set }
    var currentSearchQuery: String? { get set }
    var searchResult: PixSearchResult? { get set }
}

class ImageSearchInteractor: ImageSearchBusinessLogic, ImageSearchDataStore {
    var presenter: ImageSearchPresentationLogic?
    var storageWorker: ImageSearchStorageWorker?
    var networkWorker: ImageSearchNetworkWorker?
    
    // MARK: DataStore
    var savedQueries: [String] = []
    var currentSearchQuery: String?
    var searchResult: PixSearchResult?
    
    // MARK: Business Logic
    func fetchSavedQueries() {
        storageWorker = ImageSearchStorageWorker()
        savedQueries = storageWorker?.getSavedQueriesFromDB() ?? []
        presenter?.presentQueries(with: savedQueries)
    }
    
    func searchImages(query: String) {
        presenter?.showLoader()
        networkWorker = ImageSearchNetworkWorker()
        networkWorker?.searchWithQuery(query, completion: { [weak self] (result) in
            self?.presenter?.hideLoader()
            switch result {
            case .failure(let error):
                self?.presenter?.showError(error.localizedDescription)
            case .success(let data):
                guard let response = data, response.imageList?.isEmpty == false else {
                    self?.presenter?.showError("No Results found")
                    return
                }
                self?.searchImagesCompleted(query: query, result: response)
            }
        })
    }
    
    func searchImagesCompleted(query: String, result: PixSearchResult) {
        searchResult = result
        storageWorker = ImageSearchStorageWorker()
        storageWorker?.saveQueryInDB(query)
        currentSearchQuery = query
        presenter?.presentList()
    }
}

//
//  ResultsListInteractor.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

protocol ResultsListBusinessLogic: AnyObject {
    func fetchMoreImages()
}

protocol ResultsListDataStore {
    var currentSearchQuery: String? { get set }
    var searchResult: PixSearchResult? { get set }
}

class ResultsListInteractor: ResultsListBusinessLogic, ResultsListDataStore {
    var presenter: ResultsListPresentationLogic?
    var networkWorker: ImageSearchNetworkWorker?
    
    // MARK: DataStore
    var searchResult: PixSearchResult?
    var currentSearchQuery: String?
    
    var currentPage = 1
    var isFetchingMoreImages = false
    
    // MARK: Business Logic
    func fetchMoreImages() {
        guard let searchQuery = currentSearchQuery, !isFetchingMoreImages, (searchResult?.totalHits ?? 0 > searchResult?.imageList?.count ?? 0) else { return }
        networkWorker = ImageSearchNetworkWorker()
        isFetchingMoreImages = true
        networkWorker?.searchWithQuery(searchQuery, page: currentPage + 1, completion: { [weak self] (result) in
            self?.isFetchingMoreImages = false
            switch result {
            case .failure:
                break
            case .success(let data):
                self?.addFetchedImages(data?.imageList ?? [])
            }
        })
    }
    
    func addFetchedImages(_ images: [PixImages]) {
        currentPage += 1
        let originalCount = searchResult?.imageList?.count ?? 0
        searchResult?.imageList?.append(contentsOf: images)
        let newCount = searchResult?.imageList?.count ?? 0
        presenter?.updateFetchedImages(originalCount: originalCount, newCount: newCount)
    }
}

//
//  ImageSearchPresenter.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

protocol ImageSearchPresentationLogic: AnyObject {
    func presentQueries(with queries: [String])
    func presentList()
    func showError(_ errorMessage: String)
    func showLoader()
    func hideLoader()
}

class ImageSearchPresenter: ImageSearchPresentationLogic {
    weak var viewController: ImageSearchDisplayLogic?
    
    // MARK: Presentation Logic
    func presentQueries(with queries: [String]) {
        // Modify Queries to View Model
        // Skip for now as we are using Strings
        viewController?.setSearchQueriesInView(queries: queries)
    }
    
    func presentList() {
        viewController?.showResultList()
    }
    
    func showLoader() {
        viewController?.showLoader()
    }
    
    func hideLoader() {
        viewController?.hideLoader()
    }
    
    func showError(_ errorMessage: String) {
        
    }
}

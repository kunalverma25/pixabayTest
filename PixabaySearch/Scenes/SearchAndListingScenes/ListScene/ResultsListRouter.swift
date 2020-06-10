//
//  ResultsListRouter.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

@objc protocol ResultsListRoutingLogic: AnyObject {
    func routeToFullScreenImage(segue: UIStoryboardSegue?)
}

protocol ResultsListDataPassing {
    var dataStore: ResultsListDataStore? { get }
}

class ResultsListRouter: NSObject, ResultsListRoutingLogic, ResultsListDataPassing {
    weak var viewController: ResultsListViewController?
    var dataStore: ResultsListDataStore?
    
    // MARK: Routing
    func routeToFullScreenImage(segue: UIStoryboardSegue?) {
        guard let segue = segue else { return }
        guard let destVC = segue.destination as? FullScreenImageViewController, var destDS = destVC.router?.dataStore else { return }
        guard let ds = dataStore else { return }
        passDataToResultList(source: ds, dest: &destDS)
    }
    
    func passDataToResultList(source: ResultsListDataStore, dest: inout FullScreenImageDataStore) {
        dest.images = source.searchResult?.imageList
        dest.index = viewController?.selectedIndex
    }
}

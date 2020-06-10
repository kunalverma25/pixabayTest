//
//  ImageSearchRouter.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

@objc protocol ImageSearchRoutingLogic: AnyObject {
    func routeToResultList(segue: UIStoryboardSegue?)
}

protocol ImageSearchDataPassing {
    var dataStore: ImageSearchDataStore? { get }
}

class ImageSearchRouter: NSObject, ImageSearchRoutingLogic, ImageSearchDataPassing {
    weak var viewController: ImageSearchViewController?
    var dataStore: ImageSearchDataStore?
    
    // MARK: Routing
    func routeToResultList(segue: UIStoryboardSegue?) {
        guard let segue = segue else { return }
        guard let destVC = segue.destination as? ResultsListViewController, var destDS = destVC.router?.dataStore else { return }
        guard let ds = dataStore else { return }
        passDataToResultList(source: ds, dest: &destDS)
    }
    
    func passDataToResultList(source: ImageSearchDataStore, dest: inout ResultsListDataStore) {
        dest.searchResult = source.searchResult
    }
}
